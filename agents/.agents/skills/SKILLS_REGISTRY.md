# Codex Skills Registry

Last reviewed: 2026-07-01

Audit scope: `$HOME/.agents/skills`. The 2026-07-01 audit found 11 tracked reusable skill folders with valid `SKILL.md` frontmatter. Generated `framer-project-*` folders are local-only and intentionally excluded from this public registry.

| Skill | Path | Purpose | Status | Important Files | Known Issues |
| --- | --- | --- | --- | --- | --- |
| `tdd` | `$HOME/.agents/skills/tdd` | Test-first implementation using red-green-refactor and behavior-focused tests. | keep | `SKILL.md`, `tests.md`, `mocking.md`, `interface-design.md`, `deep-modules.md`, `refactoring.md` | Planning section asks for user approval before coding; useful but may slow autonomous sessions. |
| `teach` | `$HOME/.agents/skills/teach` | Stateful teaching workspace with mission, resources, lessons, references, and learning records. | optional | `SKILL.md`, `MISSION-FORMAT.md`, `RESOURCES-FORMAT.md`, `LEARNING-RECORD-FORMAT.md`, `GLOSSARY-FORMAT.md` | Best for intentional learning sessions; overkill for one-off explanations. |
| `grill-with-docs` | `$HOME/.agents/skills/grill-with-docs` | Stress-test plans against project vocabulary and ADRs while updating docs inline. | keep | `SKILL.md`, `CONTEXT-FORMAT.md`, `ADR-FORMAT.md` | Project-documentation heavy; not useful for simple implementation tasks. |
| `improve-codebase-architecture` | `$HOME/.agents/skills/improve-codebase-architecture` | Find architecture friction and refactoring candidates that improve testability and AI navigation. | keep | `SKILL.md`, `LANGUAGE.md`, `HTML-REPORT.md`, `INTERFACE-DESIGN.md`, `DEEPENING.md`, `CONTEXT-FORMAT.md`, `ADR-FORMAT.md` | References were made local on 2026-06-08; still assumes the repo can be meaningfully inspected. |
| `bug-triage` | `$HOME/.agents/skills/bug-triage` | Reproduce, isolate, fix, and verify bugs with focused changes. | keep | `SKILL.md` | New skill; no field history yet. |
| `staged-diff-review` | `$HOME/.agents/skills/staged-diff-review` | Review only staged Git changes before commit. | keep | `SKILL.md` | New skill; overlaps with built-in staged-change review behavior but uses your local wording. |
| `repo-onboarding` | `$HOME/.agents/skills/repo-onboarding` | Quickly orient Codex and the user to repo structure, commands, architecture, and risks. | keep | `SKILL.md` | New skill; should stay read-only unless user asks for changes. |
| `dsa-solution-review` | `$HOME/.agents/skills/dsa-solution-review` | Review DSA solutions with brute, better, optimal progression and Java-first final code. | keep | `SKILL.md` | New skill; assumes algorithm interview context. |
| `framer` | `$HOME/.agents/skills/framer` | Orchestrate explicitly requested Framer project setup, sessions, canvas and CMS edits, code components, assets, localization, and publishing. | optional | `SKILL.md` | Requires networked CLI setup and a generated local project-scoped skill; generic website requests no longer trigger it. |
| `framer-code-components` | `$HOME/.agents/skills/framer-code-components` | Provide Framer code-component constraints, property-control references, patterns, and examples. | optional | `SKILL.md` | Supporting skill only and intentionally large; direct invocation bypasses the required base and project-scoped Framer workflow. |
| `skills-maintainer` | `$HOME/.agents/skills/skills-maintainer` | Audit and maintain the local skills folder, guide, and registry. | keep | `SKILL.md` | New skill; recommend a fresh Codex session after frontmatter changes so discovery metadata refreshes. |

## Audit Findings

- Tracked reusable skill folders: `bug-triage`, `dsa-solution-review`, `framer`, `framer-code-components`, `grill-with-docs`, `improve-codebase-architecture`, `repo-onboarding`, `skills-maintainer`, `staged-diff-review`, `tdd`, `teach`.
- Newly documented reusable skills: `framer`, `framer-code-components`.
- Generated `framer-project-*` folders remain local, untracked, and excluded from Git.
- Frontmatter check: all tracked reusable `SKILL.md` files have non-empty `name` and `description` fields.
- Missing `SKILL.md` files: none.
- Broken relative references: none.

## Status Meanings

- `keep`: useful and ready to use.
- `fix`: installed and useful but has known breakage that should be repaired soon.
- `optional`: useful only for specific workflows.
- `remove`: not recommended to keep installed.
