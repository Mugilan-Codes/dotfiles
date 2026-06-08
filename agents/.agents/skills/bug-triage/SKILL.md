---
name: bug-triage
description: Reproduce, isolate, fix, and verify a software bug with focused changes. Use when the user asks to triage a bug, debug a failure, investigate an error, find root cause, or fix a regression.
---

# Bug Triage

Use this skill for bug reports, failing tests, crashes, regressions, suspicious behavior, and production-like errors.

## Workflow

1. Capture the symptom precisely: command, error, stack trace, expected behavior, actual behavior, and affected environment.
2. Reproduce the issue locally when possible. Prefer the smallest command or interaction that demonstrates the bug.
3. Inspect the relevant code paths before changing anything.
4. Form one concrete root-cause hypothesis and test it against code or runtime evidence.
5. Make the smallest fix that addresses the root cause.
6. Add or update focused tests when the behavior is important or likely to regress.
7. Verify with the failing command, relevant tests, or a targeted manual check.

## What To Do

- Preserve unrelated user changes.
- Keep the fix scoped to the failing behavior.
- State assumptions when the bug cannot be reproduced locally.
- Prefer evidence over broad rewrites.
- Report the exact verification commands and results.

## What Not To Do

- Do not rewrite large areas before proving the root cause.
- Do not upgrade dependencies unless the bug requires it.
- Do not hide reproduction failures.
- Do not remove tests just because they fail.
- Do not change public behavior beyond the bug fix unless the user approves it.

