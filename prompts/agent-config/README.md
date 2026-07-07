# Agent-configuration prompt library

These prompts are complete starting points for a fresh Codex session working
on this repository. Paste the selected prompt into the session; do not merely
refer to its filename when the session lacks this repository context.

Canonical architecture: Git tracks local skills, intentional forks, and
approved vendored third-party skills under `agents/.agents/skills`. Relative
links under `agents/.claude/skills` expose the Claude-compatible subset.
Codex reads `$HOME/.agents/skills`. The `agents` package always uses
`stow --no-folding` so both runtime parent directories stay real. Generated
`framer-project-*` skills and broad `.codex` application state stay outside
Git.

| Task | Prompt | When to use | Mutates files | Installer | Stage/commit | Prerequisites |
| --- | --- | --- | --- | --- | --- | --- |
| Audit agent configuration | [01](01-audit-agent-configuration.md) | Establish or recheck tracked/runtime health | No | No | No | Repository access; runtime metadata if deployed |
| Add selected third-party skills | [02](02-install-third-party-skills.md) | Vendor explicitly selected upstream skills | Yes | Yes | No | Installer authority; clean or acknowledged worktree |
| Update Matt Pocock skills | [03](03-update-matt-pocock-skills.md) | Refresh the configured Matt allowlist | Yes | Yes | No | Installer authority; reviewed backup/preflight |
| Update `here-now` | [04](04-update-here-now.md) | Refresh the approved `here-now` skill | Yes | Yes | No | Installer authority; reviewed backup/preflight |
| Add a local skill | [05](05-add-local-skill.md) | Track a user-authored skill | Yes | No | No | Skill name and purpose |
| Fork a third-party skill | [06](06-fork-third-party-skill.md) | Make a reviewed local fork authoritative | Yes | No | No | Upstream, reason, and licence/provenance evidence |
| Remove a skill safely | [07](07-remove-skill-safely.md) | Remove one tracked skill and references | Yes | No | No | Skill name, reason, recovery path |
| Maintain skills and docs | [08](08-maintain-skills-and-docs.md) | Reconcile metadata after a skill change | Yes | No | No | Existing skill diff |
| Audit trackable Codex config | [09](09-audit-codex-trackable-config.md) | Reassess safe `.codex` portability | No | No | No | Metadata-only access by default |
| Validate a new machine | [10](10-validate-new-machine.md) | Test bootstrap in a disposable HOME | Temporary fixture only | No | Temporary fixture only | GNU Stow, Git, temporary disk space |
| Review and commit | [11](11-review-and-commit.md) | Perform the final full review and one commit | Index and commit | No | Yes | Explicit commit authority; validated intended diff |
| Recover a failed install | [12](12-recover-failed-install.md) | Diagnose and plan scoped recovery | Temporary evidence only by default | No | No | Failed command/output and any backup path |

Quick choices:

- Add a third-party skill: prompt 02.
- Update Matt skills: prompt 03.
- Add your own skill: prompt 05.
- Recover an interrupted or failed update: prompt 12.
- Stage and commit reviewed work: prompt 11.

Never use global skill installation, run the installer outside
`dotfiles/agents`, track generated Framer state, or broadly track `.codex`.
Only prompts 02–04 may run `npx skills@latest`; only prompt 11 routinely
authorizes staging and one commit. No prompt authorizes an automatic push.
