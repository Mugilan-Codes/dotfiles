---
name: repo-onboarding
description: Quickly orient the user and Codex to an unfamiliar repository. Use when the user asks to onboard to a repo, explain repo structure, identify key commands, summarize architecture, or find where to start.
---

# Repo Onboarding

Use this skill for first-pass repository orientation.

## Workflow

1. Inspect top-level files, package manifests, build files, README files, and config.
2. Identify the project type, runtime, package manager, test commands, build commands, and dev server commands.
3. Map the main source directories and the most important entry points.
4. Look for docs such as `CONTEXT.md`, `docs/adr/`, `README.md`, and architecture notes.
5. Summarize the development workflow and likely risk areas.

## What To Produce

- What the repo is and how it appears to run.
- The main directories and what they are for.
- The most useful commands to build, test, lint, and run.
- Key files a developer should read first.
- Open questions, missing docs, or setup risks.

## What Not To Do

- Do not edit files unless the user asks.
- Do not assume commands work without checking manifests or docs.
- Do not spend time on every file; focus on orientation.
- Do not invent architecture that is not visible from code or docs.
