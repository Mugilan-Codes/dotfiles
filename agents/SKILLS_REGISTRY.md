# Agent skills registry

Last reviewed: 2026-07-07

Canonical source is `agents/.agents/skills/<name>`. `Claude` means a tracked
relative link exists under `agents/.claude/skills`; `Codex-only` means no such
link is intended.

| Name | Ownership | Source | Targets | Dependencies | Update method | Current status |
| --- | --- | --- | --- | --- | --- | --- |
| `bug-triage` | Local | This repository | Codex, Claude | None | Edit locally | Tracked local source |
| `dsa-solution-review` | Local | This repository | Codex, Claude | None | Edit locally | Tracked local source |
| `repo-onboarding` | Local | This repository | Codex, Claude | None | Edit locally | Tracked local source |
| `skills-maintainer` | Local | This repository | Codex, Claude | `scripts/agent-skills` | Edit locally | Tracked local maintenance guide |
| `staged-change-reviewer` | Local | Imported from the unique user-authored `$HOME/.codex/skills` copy | Codex-only | None | Edit locally | Codex-only; no Claude link |
| `staged-diff-review` | Local | This repository | Codex, Claude | None | Edit locally | Distinct staged-diff review workflow |
| `framer` | Local fork | Framer agent-generated base | Codex, Claude | `framer-code-components`, generated `framer-project-*` | Manual upstream review | Intentional fork; generated project state excluded |
| `framer-code-components` | Local fork | Framer agent-generated base | Codex, Claude | `framer`, generated `framer-project-*` | Manual upstream review | Intentional fork; generated project state excluded |
| `loopy` | Local fork | `Forward-Future/loopy` | Codex, Claude | None | Manual upstream review | Intentional fork; manual upstream review |
| `code-review` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None required | Project-scoped `skills@latest add` | Lock hash validated |
| `codebase-design` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `domain-modeling` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `grill-with-docs` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `grilling`, `domain-modeling` | Project-scoped installer | Lock hash validated; `grilling` retained |
| `grilling` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated; retained dependency |
| `handoff` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `improve-codebase-architecture` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `codebase-design`, `domain-modeling`, `grilling` | Project-scoped installer | Lock hash validated |
| `setup-matt-pocock-skills` | Vendored third-party | `mattpocock/skills` | Codex, Claude | Optional broader Matt workflows | Project-scoped installer | Lock hash validated |
| `tdd` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `codebase-design` vocabulary where used | Project-scoped installer | Lock hash validated |
| `teach` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `here-now` | Vendored third-party | `heredotnow/skill` | Codex, Claude | Upstream network/tools | Project-scoped `skills@latest add` | Lock hash validated; install-policy note patched; scripts executable |

## Runtime-only generated entry

| Name | Ownership | Source | Targets | Dependencies | Update method | Current status |
| --- | --- | --- | --- | --- | --- | --- |
| `framer-project-*` | Generated runtime | Framer project generation | Runtime Codex and Claude | `framer` | Regenerate through an authorized Framer workflow | Preserved outside Git |

## Verified installer metadata

- Installer specification: `skills@latest`
- Resolved installer version observed during the last vendoring audit:
  `1.5.14`
- Matt upstream HEAD observed after the last project-scoped installation:
  `16a2a5cd00b4416f673f4ff38c7971a04dd708e7`
- here-now upstream HEAD observed after the last project-scoped installation:
  `f6e7ddb92f51bed76ff4dc8f99457c14b83577e6`
- The installer lock records content hashes but no immutable upstream
  revision. The observed HEADs are provenance evidence, not claimed pins.

## Ownership invariants

- Every tracked name has exactly one ownership class.
- Local and forked names never appear in installer allowlists.
- Approved third-party contents and `skills-lock.json` are Git-visible.
- Generated Framer state remains outside Git.
- No tracked skill depends on a local upstream clone.
- `$HOME/.codex` remains application-managed.
