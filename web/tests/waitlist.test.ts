import { test } from "node:test";
import assert from "node:assert/strict";
import { createWaitlistHandler } from "../lib/waitlist.ts";

const config = {
  supabaseUrl: "https://database.example",
  serviceKey: "server-only",
  turnstileSecret: "verification-secret",
};
const payload = {
  email: " Reader@Example.com ",
  token: "verified-token",
  website: "",
};
function request(body: unknown = payload, origin = "https://dialogue.example") {
  return new Request("https://dialogue.example/api/waitlist", {
    method: "POST",
    headers: { origin, "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}
function mock(
  saved: Response,
  verification: unknown = {
    success: true,
    hostname: "dialogue.example",
    action: "waitlist",
  },
) {
  const calls: { url: string; init?: RequestInit }[] = [];
  const fetcher: typeof fetch = async (url, init) => {
    calls.push({ url: String(url), init });
    return calls.length === 1 ? Response.json(verification) : saved;
  };
  return { calls, fetcher };
}

test("valid signup normalizes email and uses server credentials", async () => {
  const { calls, fetcher } = mock(new Response(null, { status: 201 }));
  const result = await createWaitlistHandler(config, fetcher)(request());
  assert.equal(result.status, 200);
  assert.equal(calls.length, 2);
  assert.deepEqual(JSON.parse(calls[1].init?.body as string), {
    email: "reader@example.com",
    source: "web",
  });
  assert.equal(
    new Headers(calls[1].init?.headers).get("apikey"),
    "server-only",
  );
  assert.equal(result.headers.get("cache-control"), "no-store");
});

test("new and duplicate addresses receive the same response", async () => {
  const fresh = mock(new Response(null, { status: 201 }));
  const duplicate = mock(
    Response.json(
      { code: "23505", details: "private address" },
      { status: 409 },
    ),
  );
  const a = await createWaitlistHandler(config, fresh.fetcher)(request());
  const b = await createWaitlistHandler(config, duplicate.fetcher)(request());
  assert.equal(a.status, b.status);
  assert.equal(await a.text(), await b.text());
});

test("rejects cross-origin requests and oversized or malformed input before contacting services", async () => {
  let calls = 0;
  const fetcher: typeof fetch = async () => {
    calls++;
    throw Error("must not fetch");
  };
  const handler = createWaitlistHandler(config, fetcher);
  assert.equal(
    (await handler(request(payload, "https://attacker.example"))).status,
    403,
  );
  for (const body of [
    null,
    { ...payload, email: "invalid" },
    { ...payload, email: "a".repeat(255) + "@example.com" },
    { ...payload, padding: "x".repeat(5000) },
  ]) {
    assert.equal((await handler(request(body))).status, 400);
  }
  assert.equal(calls, 0);
});

test("missing configuration fails closed", async () => {
  assert.equal((await createWaitlistHandler({})(request())).status, 503);
});

test("invalid, wrong-host, or wrong-action challenges cannot reach the database", async () => {
  for (const verification of [
    { success: false },
    { success: true, hostname: "attacker.example", action: "waitlist" },
    { success: true, hostname: "dialogue.example", action: "other" },
  ]) {
    const { calls, fetcher } = mock(
      new Response(null, { status: 201 }),
      verification,
    );
    assert.equal(
      (await createWaitlistHandler(config, fetcher)(request())).status,
      400,
    );
    assert.equal(calls.length, 1);
  }
});

test("network failures and database errors produce a recoverable private response", async () => {
  const failed: typeof fetch = async () => {
    throw new Error("private connection detail");
  };
  const result = await createWaitlistHandler(config, failed)(request());
  assert.equal(result.status, 503);
  assert.doesNotMatch(await result.text(), /private connection/);
  const { fetcher } = mock(
    Response.json({ message: "private database detail" }, { status: 500 }),
  );
  const databaseFailure = await createWaitlistHandler(
    config,
    fetcher,
  )(request());
  assert.equal(databaseFailure.status, 503);
  assert.doesNotMatch(await databaseFailure.text(), /private database/);
});
