#!/usr/bin/env python3
"""Monthly agent-access review export.

Checks the live agent files, pulls the traffic summary from Supabase when the
service secrets exist, prunes log rows older than 180 days, and writes
docs/agent-review/YYYY-MM-DD.json. Standard library only.

Env: SITE_URL (default https://dialogue-five.vercel.app), SUPABASE_URL,
SUPABASE_SERVICE_ROLE_KEY (both optional; the traffic part is skipped without them).
"""

import datetime
import json
import os
import pathlib
import urllib.error
import urllib.request

SITE = os.environ.get("SITE_URL", "https://dialogue-five.vercel.app").rstrip("/")
EM = "—"
EN = "–"

CHECKS = [
    # path, expected content-type prefix, max bytes, canonical link expected
    ("/llms.txt", "text/plain", 10_000, False),
    ("/llms/how-it-works.md", "text/markdown", 60_000, True),
    ("/llms/privacy-stance.md", "text/markdown", 60_000, True),
    ("/index.md", "text/markdown", 60_000, True),
    ("/support.md", "text/markdown", 60_000, True),
    ("/privacy.md", "text/markdown", 60_000, True),
    ("/robots.txt", "text/plain", 10_000, False),
    ("/sitemap.xml", "application/xml", 50_000, False),
]


def fetch(url, method="GET", headers=None, body=None):
    req = urllib.request.Request(url, data=body, method=method, headers=headers or {})
    req.add_header("User-Agent", "dialogue-agent-review/1.0")
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return r.status, dict(r.headers), r.read()
    except urllib.error.HTTPError as e:
        return e.code, dict(e.headers), e.read()
    except Exception as e:  # network failure is a finding, not a crash
        return 0, {}, str(e).encode()


def live_checks():
    results = []
    for path, ctype, limit, canonical in CHECKS:
        status, headers, body = fetch(SITE + path)
        text = body.decode("utf-8", "replace")
        low = {k.lower(): v for k, v in headers.items()}
        problems = []
        if status != 200:
            problems.append(f"status {status}")
        if not low.get("content-type", "").startswith(ctype):
            problems.append(f"content-type {low.get('content-type')}")
        if len(body) > limit:
            problems.append(f"{len(body)} bytes over {limit}")
        if EM in text or EN in text:
            problems.append("contains a dash the copy rules ban")
        if canonical and 'rel="canonical"' not in low.get("link", ""):
            problems.append("missing canonical Link header")
        if path == "/robots.txt" and "Content-Signal:" not in text:
            problems.append("missing Content-Signal")
        results.append({"path": path, "ok": not problems, "problems": problems, "bytes": len(body)})
    # The HTML pages must advertise their twins in the server HTML.
    for path, twin in [("/", "/index.md"), ("/support", "/support.md"), ("/privacy", "/privacy.md")]:
        status, _, body = fetch(SITE + path)
        ok = status == 200 and f'type="text/markdown"' in body.decode("utf-8", "replace") and twin in body.decode("utf-8", "replace")
        results.append({"path": path, "ok": ok, "problems": [] if ok else ["no markdown alternate link"], "bytes": len(body)})
    return results


def rpc(name, payload):
    url = os.environ["SUPABASE_URL"].rstrip("/") + "/rest/v1/rpc/" + name
    key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
    status, _, body = fetch(
        url, "POST",
        {"apikey": key, "authorization": f"Bearer {key}", "content-type": "application/json"},
        json.dumps(payload).encode(),
    )
    if status != 200:
        return {"error": f"status {status}", "detail": body.decode("utf-8", "replace")[:300]}
    return json.loads(body)


def traffic():
    if not (os.environ.get("SUPABASE_URL") and os.environ.get("SUPABASE_SERVICE_ROLE_KEY")):
        return {"status": "skipped, SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are not set"}
    summary = rpc("dialogue_agent_review", {"p_days": 30})
    pruned = rpc("dialogue_agent_prune", {"p_days": 180})
    return {"status": "ok", "summary": summary, "pruned_rows": pruned}


def main():
    today = datetime.datetime.now(datetime.timezone.utc).date().isoformat()
    checks = live_checks()
    out = {
        "date": today,
        "site": SITE,
        "live_checks": checks,
        "live_checks_ok": all(c["ok"] for c in checks),
        "traffic": traffic(),
    }
    path = pathlib.Path("docs/agent-review") / f"{today}.json"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {path}; live checks ok: {out['live_checks_ok']}; traffic: {out['traffic']['status']}")


if __name__ == "__main__":
    main()
