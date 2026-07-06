# Agent Skills

This directory declares skill ownership and desired state. Runtime
installation is managed by `scripts/agent-skills`; `agents` is not a GNU Stow
package.

## Ownership Categories

| Category | Source of truth | Runtime |
| --- | --- | --- |
| Dotfiles-owned local skill | `agents/skills/<name>` | Individual link at `$HOME/.agents/skills/<name>` |
| Intentional local fork | `agents/skills/<name>` plus attribution | Individual link at `$HOME/.agents/skills/<name>` |
| CLI-managed third-party skill | Source and allowlist in `agents/skills.conf` | CLI-managed directory at `$HOME/.agents/skills/<name>` |
| Generated Framer project skill | Machine-local generated state | Real directory at `$HOME/.agents/skills/framer-project-*` |

Claude Code receives individual links under `$HOME/.claude/skills`. Codex
reads the canonical `$HOME/.agents/skills` view. No duplicate user-managed
copy is created under `$HOME/.codex/skills`.

Third-party installed contents are not committed because upstream owns them
and the pinned CLI can reproduce the explicit selection. This avoids stale
vendored snapshots while retaining reviewable desired state.

## Configuration

`agents/skills.conf` is shell-quoted data sourced by the Bash wrapper. It
declares:

- `SKILLS_CLI_VERSION`
- global installation scope
- symlink installation mode
- target agent IDs
- each GitHub source and explicit skill allowlist
- local skill names
- the generated runtime pattern
- that a local Matt Pocock clone is not required

Values must remain data-only. Do not add commands or machine-specific absolute
paths.

## Commands

Run from any directory inside the repository:

```sh
scripts/agent-skills plan
scripts/agent-skills install
scripts/agent-skills status
scripts/agent-skills update
scripts/agent-skills unlink-local
```

### `plan`

Read-only. Reports the required/available CLI version, configured sources and
skills, expected targets, missing entries, stale/broken links, real-directory
collisions, duplicate names, local source paths, local-clone references, and
the changes `install` would make.

### `install`

Installs only missing third-party allowlist entries with the pinned CLI,
global scope, Codex and Claude Code targets, and default symlink mode. It then
creates individual local and generated compatibility links.

It refuses a whole-directory `$HOME/.agents/skills` symlink, real-directory
collisions, unexpected symlinks, source mismatches, and local drift in
CLI-managed contents.

CLI 1.5.14 cannot remove a stale lock record after its runtime directory is
already absent. During `install`, the wrapper atomically removes lock entries
only for names explicitly owned by `LOCAL_SKILLS`, only after collision
preflight, and only for the supported lock-file format. It does not remove
runtime contents in that reconciliation.

### `status`

Runs the pinned CLI global list and validates:

- every configured third-party source and runtime directory
- local and Claude Code links
- generated compatibility links
- `SKILL.md` frontmatter and directory/name agreement
- relative Markdown references
- duplicate names and independent Codex collisions
- broken links, unexpected copies, and links into a removable local clone
- wrapper-recorded content hashes for CLI-managed skills

It exits non-zero for unhealthy state.

### `update`

Updates only names in the configured third-party allowlists, reports which
content hashes changed, records the reconciled state, and runs full status
validation. It never updates dotfiles-owned local skills or changes the pinned
CLI version.

### `unlink-local`

Removes only exact symlinks owned by `LOCAL_SKILLS`. It refuses real
directories and unexpected links. It does not touch third-party or generated
contents, or Codex system/plugin skills.

## Local Skill Lifecycle

1. Create or edit `agents/skills/<name>`.
2. Ensure `SKILL.md` has non-empty `name` and `description` frontmatter.
3. Add the name to `LOCAL_SKILLS`.
4. Update `SKILLS_REGISTRY.md`.
5. For a fork, update `THIRD_PARTY.md` with provenance and local changes.
6. Run `plan`; run `install` only when runtime mutation is authorized.
7. Start a fresh agent session after discovery-affecting changes.

Do not point the skills CLI at a source inside `$HOME/.agents/skills`.

## Third-party Skill Lifecycle

1. Review the source, license, and current selectable names.
2. Add only the intended names to the relevant allowlist.
3. Update `SKILLS_REGISTRY.md` and `THIRD_PARTY.md`.
4. Run `plan`, then an authorized `install`.
5. Use the wrapper's `update` command for future upstream changes.

Never use `--all`, a blind `@latest` command, the upstream development linker,
a copied snapshot, a submodule, or a local upstream clone as managed state.

## Generated Skills

Framer may generate `framer-project-*` directories containing project
metadata. Keep them as real machine-local directories under
`$HOME/.agents/skills`, outside Git. The wrapper links them into Claude Code
without moving them into tracked source.

## Troubleshooting

If the wrapper reports a collision:

1. Inspect with `ls -ld`, `readlink`, and `realpath`.
2. Compare contents and source records.
3. Back up ambiguous state outside the repository.
4. Remove or relocate only proven obsolete state.
5. Rerun `plan` before `install`.

If a third-party directory was edited directly, preserve the change and
decide whether to discard it or promote it to an attributed local fork. The
wrapper intentionally refuses to overwrite that drift.

If Claude Code cannot discover a skill, confirm its entry is a live symlink
to the corresponding canonical runtime path. If Codex cannot discover it,
check `$HOME/.agents/skills` and start a fresh session.
