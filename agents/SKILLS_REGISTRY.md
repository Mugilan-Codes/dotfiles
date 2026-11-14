# Agent skills registry

Last reviewed: 2026-08-04

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
| `diagnosing-bugs` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Model-invoked debugging discipline |
| `domain-modeling` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `grill-with-docs` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `grilling`, `domain-modeling` | Project-scoped installer | Lock hash validated; `grilling` retained |
| `grilling` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated; retained dependency |
| `handoff` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `improve-codebase-architecture` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `codebase-design`, `domain-modeling`, `grilling` | Project-scoped installer | Lock hash validated |
| `prototype` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Model-invoked throwaway exploration |
| `research` | Vendored third-party | `mattpocock/skills` | Codex, Claude | Background-agent capability | Project-scoped installer | Model-invoked primary-source research |
| `setup-matt-pocock-skills` | Vendored third-party | `mattpocock/skills` | Codex, Claude | Optional broader Matt workflows | Project-scoped installer | Lock hash validated |
| `tdd` | Vendored third-party | `mattpocock/skills` | Codex, Claude | `codebase-design` vocabulary where used | Project-scoped installer | Lock hash validated |
| `teach` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | Lock hash validated |
| `to-spec` | Vendored third-party | `mattpocock/skills` | Codex, Claude | Setup-provided tracker/domain docs | Project-scoped installer | User-invoked spec publication |
| `to-tickets` | Vendored third-party | `mattpocock/skills` | Codex, Claude | Setup-provided tracker; optional `prototype`; ordinary Codex implementation | Project-scoped installer plus documented local integration note | User-invoked tracer-ticket planning; `/implement` handoff replaced locally |
| `writing-great-skills` | Vendored third-party | `mattpocock/skills` | Codex, Claude | None | Project-scoped installer | User-invoked skill-writing reference |
| `here-now` | Vendored third-party | `heredotnow/skill` | Codex, Claude | Python 3, curl, jq, file, shasum | Reviewed update preserving local patches | DF-12/13 safety patch; docs/VENDOR-PATCHES.md; scripts executable |
| `design-taste-frontend` | Vendored third-party | `Leonxlnx/taste-skill` | Codex, Claude | Frontend project context; image-generation capability when available | Project-scoped `skills@latest add` | v2 experimental; landing, portfolio, and redesign surfaces only |

## Runtime-only generated entry

| Name | Ownership | Source | Targets | Dependencies | Update method | Current status |
| --- | --- | --- | --- | --- | --- | --- |
| `framer-project-*` | Generated runtime | Framer project generation | Runtime Codex and Claude | `framer` | Regenerate through an authorized Framer workflow | Preserved outside Git |

## Verified installer metadata

- Installer specification: `skills@latest`
- Resolved installer version observed during this project-scoped refresh:
  `1.5.21`
- Matt upstream HEAD observed during this project-scoped refresh:
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c`
- here-now upstream HEAD observed during this project-scoped refresh:
  `c9fad058b8f1258061a2ff8766e257a384ae97ed`
- Taste upstream HEAD observed during this project-scoped install:
  `e988add20dab0fa97d7a76781c48961c8184288e`
- The installer lock records content hashes but no immutable upstream
  revision. The observed HEADs are provenance evidence, not claimed pins.

`design-taste-frontend` is the upstream v2 experimental default. It is
contextual model guidance, not a hook or background process; its rules apply
to landing pages, portfolios, and redesigns, and it explicitly excludes
dashboards, data tables, multi-step forms, code editors, native mobile, and
realtime collaboration surfaces.

## Ownership invariants

- Every tracked name has exactly one ownership class.
- Local and forked names never appear in installer allowlists.
- Approved third-party contents and `skills-lock.json` are Git-visible.
- Generated Framer state remains outside Git.
- No tracked skill depends on a local upstream clone.
- `$HOME/.codex` remains application-managed.

## Lifecycle metadata

`skills-manifest.json` records content hashes, origin/revision limitations,
supported agents, dependencies and local patch evidence for every managed
package. `scripts/agent-skills` adds reviewed imports to this table and the
manifest; existing ownership allowlists remain in `skills.conf`. See
`external-skills.json` for installer-owned siblings and the six unresolved
workflow packages. An empty dependency list means no fixed external runtime
is required to read that instruction package, not that every possible project
workflow can run without project-specific tools.
