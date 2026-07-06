---
name: staged-diff-review
description: Review only staged Git changes and produce a concise pre-commit review. Use when the user asks to review staged changes, review git add changes, summarize staged diff, or ignore unstaged work.
---

# Staged Diff Review

Use this skill when the review target is exactly the staged Git diff.

## Workflow

1. Run `git diff --staged --stat` to understand scope.
2. Run `git diff --staged` and inspect the actual staged changes.
3. Review as a code reviewer: bugs, regressions, missing tests, risky behavior, and unclear intent first.
4. Ignore unstaged changes unless they affect whether staged code can be understood.
5. Report findings before summaries.

## Output Shape

- Findings first, ordered by severity, with file and line references when available.
- Open questions or assumptions next.
- Brief change summary last.
- If there are no findings, say that clearly and mention residual risk or unverified behavior.

## What Not To Do

- Do not review the whole worktree unless the user asks.
- Do not modify files during the review.
- Do not treat style preferences as findings unless they create real risk.
- Do not include unstaged or untracked files in the review scope.
