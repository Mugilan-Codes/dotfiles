# Agent skills registry

Last reviewed: 2026-07-06

Canonical source is `agents/.agents/skills/<name>`. `Claude` means a tracked
relative link exists under `agents/.claude/skills`; `Codex-only` means no such
link is intended.

| Name | Ownership | Source | Targets | Dependencies | Update method | Phase 2 content result |
| --- | --- | --- | --- | --- | --- | --- |
| `bug-triage` | Local | This repository | Codex, Claude | None | Edit locally | Moved byte-for-byte |
| `dsa-solution-review` | Local | This repository | Codex, Claude | None | Edit locally | Moved byte-for-byte |
| `repo-onboarding` | Local | This repository | Codex, Claude | None | Edit locally | Moved byte-for-byte |
| `skills-maintainer` | Local | This repository | Codex, Claude | `scripts/agent-skills` | Edit locally | Rewritten for vendored Stow model |
| `staged-change-reviewer` | Local | Imported from the unique user-authored `$HOME/.codex/skills` copy | Codex-only | None | Edit locally | Imported byte-for-byte |
| `staged-diff-review` | Local | This repository | Codex, Claude | None | Edit locally | Moved byte-for-byte |
| `framer` | Local fork | Framer agent-generated base | Codex, Claude | `framer-code-components`, generated `framer-project-*` | Manual upstream review | Moved byte-for-byte |
| `framer-code-components` | Local fork | Framer agent-generated base | Codex, Claude | `framer`, generated `framer-project-*` | Manual upstream review | Moved byte-for-byte |
| `loopy` | Local fork | `Forward-Future/loopy` | Codex, Claude | None | Manual upstream review | Moved byte-for-byte |
| `code-review` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None required | Project-scoped `skills@latest add` | Imported runtime baseline; latest unchanged |
| `codebase-design` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `domain-modeling` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `grill-with-docs` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `grilling`, `domain-modeling` | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `grilling` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | CLI help defect updated runtime before backup; real project install then matched imported baseline |
| `handoff` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `improve-codebase-architecture` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `codebase-design`, `domain-modeling`, `grilling` | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `setup-matt-pocock-skills` | Vendored third-party | `mattpocock/skills` | Codex, Claude | Optional broader Matt workflows | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `tdd` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `codebase-design` vocabulary where used | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `teach` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Imported runtime baseline; latest unchanged |
| `here-now` | Vendored third-party | `heredotnow/skill` | Codex, Claude | Upstream network/tools | Project-scoped `skills@latest add` | Imported runtime baseline; latest unchanged |

## Runtime-only generated entry

| Name | Ownership | Source | Targets | Dependencies | Update method | Phase 2 content result |
| --- | --- | --- | --- | --- | --- | --- |
| `framer-project-*` | Generated runtime | Framer project generation | Runtime Codex and Claude | `framer` | Regenerate through an authorized Framer workflow | Preserved outside Git |

## Verified installer metadata

- Installer specification: `skills@latest`
- Resolved installer version during Phase 2: `1.5.14`
- Matt upstream HEAD observed immediately after installation:
  `16a2a5cd00b4416f673f4ff38c7971a04dd708e7`
- here-now upstream HEAD observed immediately after installation:
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
