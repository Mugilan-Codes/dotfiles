# Codex Skills Guide

Last reviewed: 2026-06-08

This guide documents the local skills installed under `$HOME/.agents/skills`. A skill is triggered by its `name` and `description` frontmatter in `SKILL.md`; the body is loaded only after Codex decides the skill applies.

Audit note: the 2026-06-08 audit found 9 installed skill folders. Deleted skill folders are not retained as active guide entries.

## Installed Skills

| Skill | Type | Use When | Do Not Use When |
| --- | --- | --- | --- |
| `tdd` | General-purpose | You want test-first feature work, bug fixes, integration tests, or a red-green-refactor loop. | You only want a quick explanation, a spike, or throwaway code without tests. |
| `teach` | General-purpose, workspace-based | You want a stateful learning path with missions, lessons, resources, and learning records. | You only want a short answer or one-off explanation. |
| `grill-with-docs` | Project-specific | You want to stress-test a plan against project vocabulary, `CONTEXT.md`, and ADRs. | You want implementation without a design conversation. |
| `improve-codebase-architecture` | Project-specific | You want architecture review, refactoring candidates, deeper modules, or better testability. | You already know the exact change to make, or the repo has no meaningful codebase to inspect. |
| `bug-triage` | General-purpose | You want to reproduce, isolate, fix, and verify a bug. | You are asking for a broad feature build or purely speculative debugging. |
| `staged-diff-review` | General-purpose | You want only staged Git changes reviewed before commit. | You want unstaged work, a branch diff, or a whole repository reviewed. |
| `repo-onboarding` | General-purpose | You want a fast orientation to an unfamiliar repo: structure, commands, architecture, risks. | You already gave a narrow coding task. |
| `dsa-solution-review` | General-purpose | You want a data-structures-and-algorithms solution reviewed or explained. | The problem is production application code rather than an algorithm exercise. |
| `skills-maintainer` | General-purpose | You want to audit local skills, check broken references, or update this guide and registry. | You want to modify a project repository instead of the local skills setup. |

## Exact Trigger Phrases

Use these phrases directly when you want to force the skill:

- `Use the tdd skill`
- `Use TDD`
- `red-green-refactor`
- `test-first`
- `write integration tests first`
- `Use the teach skill`
- `teach me this over multiple sessions`
- `create a learning workspace`
- `Use grill-with-docs`
- `grill this plan against the docs`
- `stress-test this plan against CONTEXT.md and ADRs`
- `Use improve-codebase-architecture`
- `find deepening opportunities`
- `review this codebase architecture`
- `make this codebase more testable and AI-navigable`
- `Use bug-triage`
- `triage this bug`
- `reproduce, isolate, fix, and verify this bug`
- `Use staged-diff-review`
- `review only staged changes`
- `summarize my git add changes`
- `Use repo-onboarding`
- `onboard me to this repo`
- `explain the repo structure and dev workflow`
- `Use dsa-solution-review`
- `review my DSA solution`
- `compare my solution against TUF+`
- `Use skills-maintainer`
- `audit my local skills`
- `update my skills guide`
- `check my Codex skills setup`
- `a new skill was added`
- `a skill was updated`

## Example Prompts

- `Use the tdd skill to add pagination to this endpoint.`
- `Fix this bug with red-green-refactor and keep tests behavior-focused.`
- `Use the teach skill to teach me Redis over multiple sessions.`
- `Create a learning workspace for system design interviews.`
- `Use grill-with-docs to stress-test this checkout redesign against CONTEXT.md and ADRs.`
- `Use improve-codebase-architecture to find refactoring opportunities in this repo.`
- `Use bug-triage to reproduce, isolate, fix, and verify this crash.`
- `Use staged-diff-review to review only my staged Git changes before commit.`
- `Use repo-onboarding to explain this repo's structure, commands, and main risks.`
- `Use dsa-solution-review to review my Java solution and compare against TUF+ notes.`
- `Explain brute, better, and optimal approaches for this DSA problem in Java.`
- `Use skills-maintainer to audit my local skills and update the guide and registry.`

## Usage Notes

- `grill-with-docs` has valid frontmatter and required files. Its `CONTEXT-FORMAT.md` multi-context paths are illustrative examples, not required files.
- `teach` is intentionally marked optional in the registry because it is a stateful teaching workflow and is too heavy for one-off explanations.
- Start a fresh Codex session after adding, removing, renaming, or changing `SKILL.md` frontmatter so skill discovery metadata refreshes.

## Updating This Guide

When a skill is added, removed, renamed, or materially changed:

- Re-read `$HOME/.agents/skills/*/SKILL.md`.
- Add or update its row in this guide.
- Add exact trigger phrases that match the skill description.
- Add at least one practical example prompt.
- Update `$HOME/.agents/skills/SKILLS_REGISTRY.md` on the same day.
- Record compatibility notes or known issues instead of hiding them.
- Use `skills-maintainer` after adding or changing a skill.
