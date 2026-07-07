---
name: staged-change-reviewer
description: Review only staged Git changes and produce a concise change review that explains files changed, what changed, why it changed, key risks, and useful verification commands. Use when the user asks to review the current staged diff, summarize `git add`ed changes before commit, or explicitly says to ignore unstaged worktree changes.
---

# Staged Change Reviewer

Review the staged diff only. Treat unstaged and untracked files as out of scope even if they appear related.

## Workflow

1. Confirm the staged scope first.
Run `git diff --cached --name-status` and `git diff --cached --stat` to understand which files are staged.

2. Inspect the staged patch only.
Use `git diff --cached -- <path>` for file-level review. Do not inspect or discuss `git diff`, untracked files, or working tree noise unless the user explicitly changes scope.

3. Explain the change in review language.
For each staged file or logical group of files, explain:
- what changed
- why the change appears to exist
- risks or regressions to watch

4. Give verification commands.
Prefer concrete commands the user can run locally, based on the staged change type. Examples:
- `git diff --cached --stat`
- `git diff --cached -- <path>`
- project compile or test commands relevant to the changed files

## Output Contract

Structure the response around these sections when they add value:
- files changed
- what changed
- why
- risks
- verification

Keep the review concise and specific. If there are no staged changes, say that clearly and stop.

## Guardrails

- Do not discuss unstaged files.
- Do not infer behavior from the working tree outside the staged patch.
- Do not suggest reverting unrelated changes.
- If verification cannot be run, say what was not run.
- If the staged patch is large, summarize by logical area instead of line-by-line narration.

## Command Set

Prefer these commands:

```bash
git diff --cached --name-status
git diff --cached --stat
git diff --cached -- <path>
git show :<path>
```

Use additional repo-specific compile or test commands only after identifying what the staged files changed.
