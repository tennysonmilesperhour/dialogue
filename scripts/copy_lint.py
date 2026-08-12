#!/usr/bin/env python3
"""Mechanical enforcement of the voice rules in docs/IDENTITY.md.

Three rules, checked across every tracked text file:

  1. No em dashes, anywhere. Commas, parentheses, or a rewrite.
  2. No exclamation points in prose or user-facing strings.
  3. No emoji in prose or user-facing strings.

Rules 2 and 3 are scoped so code is not mistaken for copy: Swift is checked
inside string literals only (a force unwrap is not an exclamation), markdown
is checked outside fenced code blocks, and TypeScript is checked with a
heuristic that skips the not-operator and non-null assertions.

Quoting a rule-breaking line on purpose (docs/IDENTITY.md lists the copy the
app must never sound like) is legitimate. Two escape hatches:

  copy-lint: allow    on the same line
  copy-lint: off      suspends checking until copy-lint: on

Run with no arguments to check the whole repo. Exit code 1 on any finding.
"""

from __future__ import annotations

import pathlib
import re
import subprocess
import sys

EM_DASH = "—"
HORIZONTAL_BAR = "―"

EMOJI = re.compile(
    "["
    "\U0001f000-\U0001faff"
    "☀-➿"
    "⬀-⯿"
    "\U0001f1e6-\U0001f1ff"
    "️"
    "]"
)

# An exclamation that ends a word, versus `!=`, `!x`, or `foo!.bar`.
PROSE_BANG = re.compile(r"(?<=[\w\"')\]])!(?=$|[\s\"'<)}])")

SWIFT_STRING = re.compile(r'"(?:[^"\\\n]|\\.)*"')

TEXT_SUFFIXES = {
    ".md", ".swift", ".ts", ".tsx", ".js", ".jsx",
    ".css", ".sql", ".yml", ".yaml", ".json", ".html", ".txt",
}

SKIP_PATHS = {
    "scripts/copy_lint.py",   # the patterns above are not copy
    "web/package-lock.json",
}


def tracked_files() -> list[pathlib.Path]:
    out = subprocess.run(
        ["git", "ls-files"], capture_output=True, text=True, check=True
    ).stdout.splitlines()
    files = []
    for name in out:
        if name in SKIP_PATHS:
            continue
        path = pathlib.Path(name)
        if path.suffix in TEXT_SUFFIXES and path.is_file():
            files.append(path)
    return files


def prose_segments(path: pathlib.Path, lines: list[str]) -> list[tuple[int, str]]:
    """Return (line number, text) for the parts of a file that are copy."""
    suffix = path.suffix
    segments: list[tuple[int, str]] = []

    if suffix == ".swift":
        for number, line in enumerate(lines, start=1):
            for match in SWIFT_STRING.finditer(line):
                segments.append((number, match.group()))
        return segments

    if suffix == ".md":
        in_fence = False
        for number, line in enumerate(lines, start=1):
            if line.lstrip().startswith("```"):
                in_fence = not in_fence
                continue
            if in_fence:
                continue
            segments.append((number, line.replace("![", "[")))
        return segments

    if suffix in {".ts", ".tsx", ".js", ".jsx", ".html", ".txt"}:
        return list(enumerate(lines, start=1))

    # css, sql, yaml, json: emoji only, handled by the caller skipping bangs.
    return list(enumerate(lines, start=1))


def suppressed_lines(lines: list[str]) -> set[int]:
    """Line numbers exempted by an allow marker or an off/on block."""
    exempt: set[int] = set()
    off = False
    for number, line in enumerate(lines, start=1):
        if "copy-lint: off" in line:
            off = True
        if off:
            exempt.add(number)
        if "copy-lint: on" in line:
            off = False
        if "copy-lint: allow" in line:
            exempt.add(number)
    return exempt


def check(path: pathlib.Path) -> list[str]:
    findings: list[str] = []
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except UnicodeDecodeError:
        return findings

    exempt = suppressed_lines(lines)

    for number, line in enumerate(lines, start=1):
        if number in exempt:
            continue
        if EM_DASH in line or HORIZONTAL_BAR in line:
            findings.append(f"{path}:{number}: em dash. Use a comma, parentheses, or rewrite.")

    bangs_apply = path.suffix not in {".css", ".sql", ".yml", ".yaml", ".json"}
    for number, text in prose_segments(path, lines):
        if number in exempt:
            continue
        if bangs_apply and PROSE_BANG.search(text):
            findings.append(f"{path}:{number}: exclamation point in copy.")
        if EMOJI.search(text):
            findings.append(f"{path}:{number}: emoji in copy.")

    return findings


def main() -> int:
    findings: list[str] = []
    for path in tracked_files():
        findings.extend(check(path))

    if findings:
        print("Copy lint failed. See docs/IDENTITY.md for the voice rules.\n")
        for finding in findings:
            print(finding)
        print(f"\n{len(findings)} finding(s).")
        return 1

    print("Copy lint passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
