# Agent Skills Registry

Last reviewed: 2026-07-06

Target agents are Codex and Claude Code unless noted. Runtime is canonical
under `$HOME/.agents/skills`; Claude Code receives compatibility links under
`$HOME/.claude/skills`.

| Name | Ownership | Source | Local source | Installation | Dependencies | Fork | Update method | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `bug-triage` | Local | This dotfiles repo | `agents/skills/bug-triage` | Wrapper link | None | No | Edit locally | Focused reproduce/isolate/fix/verify workflow. |
| `dsa-solution-review` | Local | This dotfiles repo | `agents/skills/dsa-solution-review` | Wrapper link | None | No | Edit locally | Java-first brute/better/optimal review workflow. |
| `framer` | Local fork | Framer agent-generated base | `agents/skills/framer` | Wrapper link | `framer-code-components`, generated `framer-project-*` | Yes | Manual upstream review | Dotfiles copy is authoritative; preserves narrower trigger, permission/privacy policy, and generated-state warning. |
| `framer-code-components` | Local fork | Framer agent-generated base | `agents/skills/framer-code-components` | Wrapper link | `framer`, generated `framer-project-*` | Yes | Manual upstream review | Dotfiles copy is authoritative; preserves corrected `framer-property-control-types` anchor. |
| `loopy` | Local fork | `Forward-Future/loopy` | `agents/skills/loopy` | Wrapper link | None | Yes | Manual upstream review | Tracked intentionally with its references and OpenAI metadata; never updated by the CLI wrapper. |
| `repo-onboarding` | Local | This dotfiles repo | `agents/skills/repo-onboarding` | Wrapper link | None | No | Edit locally | Read-only repository orientation workflow. |
| `skills-maintainer` | Local | This dotfiles repo | `agents/skills/skills-maintainer` | Wrapper link | `scripts/agent-skills` | No | Edit locally | Understands local, CLI-managed, and generated ownership categories. |
| `staged-diff-review` | Local | This dotfiles repo | `agents/skills/staged-diff-review` | Wrapper link | None | No | Edit locally | Reviews only Git index changes. |
| `code-review` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | None required | No | `scripts/agent-skills update` | Review against repository standards and originating spec. |
| `codebase-design` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | None | No | Wrapper update | Shared deep-module design vocabulary. |
| `domain-modeling` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | None | No | Wrapper update | Maintains ubiquitous language and architectural decisions. |
| `grill-with-docs` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | `grilling`, `domain-modeling` | No | Wrapper update | `grilling` is explicitly allowlisted because this skill invokes it. |
| `grilling` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | None | No | Wrapper update | Required interview engine for `grill-with-docs` and architecture workflows. |
| `handoff` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | None | No | Wrapper update | Creates a compact conversation handoff artifact. |
| `improve-codebase-architecture` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | `codebase-design`, `domain-modeling`, `grilling` | No | Wrapper update | Produces a visual report and grills a selected deepening opportunity. |
| `setup-matt-pocock-skills` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | Optional broader Matt workflow skills | No | Wrapper update | Selected exact name verified 2026-07-06; some setup choices may describe non-allowlisted workflows. |
| `tdd` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | `codebase-design` vocabulary where used | No | Wrapper update | Test-first red/green/refactor workflow. |
| `teach` | Third-party | `mattpocock/skills` | Not applicable | `skills@1.5.14` allowlist | None | No | Wrapper update | Stateful teaching workflow. |
| `here-now` | Third-party | `heredotnow/skill` | Not applicable | `skills@1.5.14` allowlist | Runtime network/tools documented upstream | No | Wrapper update | Selectable name verified 2026-07-06; publishing remains separately authorized. |
| `framer-project-*` | Generated runtime | Framer CLI/session generation | Never tracked | Generator creates canonical real directory; wrapper links Claude | `framer` | Not applicable | Regenerate through authorized Framer workflow | May contain private project metadata; Codex and Claude resolve the same machine-local state. |

## Source Verification

On 2026-07-06, the pinned CLI list operation confirmed all ten configured
Matt skill names and the `here-now` name exactly. No rename or ambiguous
replacement was required.

The legacy vendored copies were removed after their CLI-managed replacements
were installed, compared file-by-file, and validated for both target agents.

## Ownership Invariants

- A configured name has one owner.
- Local source is editable only under `agents/skills`.
- Third-party runtime contents are not local source and are not committed.
- Generated Framer state remains outside Git.
- No managed path depends on a local clone of `mattpocock/skills`.
