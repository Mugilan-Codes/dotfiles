# Codex Skills Guide

Last reviewed: 2026-07-06

This guide documents the local skills installed under `$HOME/.agents/skills`. A skill is triggered by its `name` and `description` frontmatter in `SKILL.md`; the body is loaded only after Codex decides the skill applies.

Audit note: the 2026-07-06 audit found 13 tracked reusable skill folders. Generated `framer-project-*` skills are local-only and excluded from Git because they may contain private project metadata.

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
| `framer` | Integration workflow | You explicitly want to design, edit, inspect, or publish a Framer project. | The request is generic website or web-development work without clear Framer context. |
| `framer-code-components` | Supporting reference | A Framer task requires creating or editing a code component after the base and project-scoped skills are loaded. | As a direct entry point; load it only through the required Framer workflow. |
| `here-now` | Integration workflow | You want to publish files or a static site with here.now, manage site access, or use a private here.now Drive. | A different hosting or storage provider is requested, or the files should remain local. |
| `loopy` | General-purpose workflow | You want to discover, find, audit, craft, run, debrief, save, adapt, or publish a bounded AI-agent loop. | The task is a one-shot workflow where fresh feedback cannot change the next action. |
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
- `Use the framer skill`
- `edit my Framer site`
- `publish my Framer project`
- `create a Framer code component`
- `Use here-now`
- `publish this with here.now`
- `host this and generate a URL`
- `save this to my here.now Drive`
- `share a Drive folder with another agent`
- `password protect this here.now site`
- `Use loopy`
- `turn this recurring work into a bounded loop`
- `find a published loop for this workflow`
- `audit this loop`
- `run this loop and return an evidence receipt`
- `debrief this loop run`
- `prepare this loop for Loop Library`
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
- `Use the framer skill to update the pricing section on my Framer site.`
- `Use Framer to create a configurable code component and add it to the canvas.`
- `Use Framer to inspect and publish my connected Framer project.`
- `Use here-now to publish this static site and give me its live URL.`
- `Use here-now to save this research folder to my Drive and create a scoped read-only share token.`
- `Use here-now to restrict this site to the email addresses I provide.`
- `Use loopy to find recurring work in these coding threads and propose one bounded loop.`
- `Use loopy to audit this loop for weak checks, unsafe authority, and missing stop conditions.`
- `Use loopy to run this saved project loop and return an evidence-backed receipt.`
- `Use skills-maintainer to audit my local skills and update the guide and registry.`

## Usage Notes

- `grill-with-docs` has valid frontmatter and required files. Its `CONTEXT-FORMAT.md` multi-context paths are illustrative examples, not required files.
- `teach` is intentionally marked optional in the registry because it is a stateful teaching workflow and is too heavy for one-off explanations.
- `framer` requires explicit Framer context, CLI setup, network access, and a project session before project work begins.
- `framer-code-components` is not a direct entry point. Load `framer`, run `session new`, load the generated project skill, and only then load it for code-component work.
- Generated `framer-project-*` skills are session/project-specific local state. Keep them out of this public registry and refresh them with `session new`.
- `here-now` requires network access plus `curl`, `file`, and `jq`. Read the live service documentation before capability guidance. Anonymous sites expire after 24 hours; permanent sites and private Drives require credentials. Never commit credentials or `.herenow/state.json`.
- `loopy` routes requests through the smallest applicable workflow. Published-loop discovery and comparison require access to the live Loop Library catalog; saving project loops and external publication require explicit user requests or approval.
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
