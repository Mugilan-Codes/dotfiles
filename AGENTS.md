# AGENTS.md

Canonical instructions for Codex, Claude Code, and other AI agents working in
this dotfiles repository.

## Repository Purpose

This personal macOS/Linux dotfiles repository tracks:

- shell startup files and Oh My Zsh customizations
- tmux, global Git, and Starship configuration
- Homebrew package state in `Brewfile`
- dotfiles-owned agent skills and declarative third-party skill configuration
- optional macOS preference automation

GNU Stow manages the `zsh`, `tmux`, `git`, and `starship` packages. The
`agents` directory is not a Stow package; `scripts/agent-skills` manages skill
runtime links.

New-machine setup and detailed commands belong in `README.md` and
`agents/README.md`.

## Working Rules

- Inspect the repository structure, relevant files, and
  `git status --short --untracked-files=all` before modifying anything.
- For non-trivial changes, state a short plan before editing.
- Preserve all pre-existing unrelated changes.
- Keep changes small, scoped, and reviewable.
- Keep commands concise and copy-pasteable.
- Do not overwrite a real home-directory file or directory. Inspect the entry
  type and resolved symlink target first.
- Do not run broad, destructive, or cleanup commands unless explicitly
  requested.
- Do not commit secrets, keys, tokens, credentials, `.env` files,
  `.DS_Store`, swap files, temporary files, generated Framer state, or
  machine-only configuration.

## Authority Boundaries

Treat these as separate permissions:

- audit or report
- edit tracked repository files
- run an installer or updater
- apply or remove Stow links
- stage changes
- commit changes
- push changes
- deploy or publish externally

An audit-only request authorizes read-only inspection, not implementation.
Editing does not authorize installation, Stow changes, staging, committing,
pushing, deployment, or external updates. Obtain explicit authority for each
mutating operation that is outside the requested scope.

## Stow Packages

- `zsh`: shell startup and Oh My Zsh custom files
- `tmux`: `$HOME/.tmux.conf`
- `git`: `$HOME/.gitconfig`
- `starship`: `$HOME/.config/starship.toml`

`macos/finder` is optional preference automation, not a Stow package. Always
simulate relevant Stow operations before applying them. Never use `--adopt`
without explicit intent to import existing home-directory contents.

## Skill Ownership

### Dotfiles-owned local skills and forks

Sources live under `agents/skills/<name>`. The wrapper links each skill
individually into `$HOME/.agents/skills/<name>` and then into
`$HOME/.claude/skills/<name>`.

Edit only the repository source. Intentional forks must have attribution,
upstream provenance, and local-change notes in `agents/THIRD_PARTY.md` and
`agents/SKILLS_REGISTRY.md`.

### CLI-managed third-party skills

Desired state lives in `agents/skills.conf`. Install and update only the
explicit allowlist with the pinned `skills` CLI through
`scripts/agent-skills`.

Installed contents under `$HOME/.agents/skills` are runtime artifacts, not
editable local source. Claude Code compatibility entries under
`$HOME/.claude/skills` must resolve to the same canonical runtime skill.
Codex reads `$HOME/.agents/skills`; do not create duplicate user-managed
copies under `$HOME/.codex/skills`, and do not alter Codex system/plugin
skills there.

Managed executable commands must use the configured pinned CLI version. Do
not use `@latest`, `--all`, an upstream development linker, a local upstream
clone, submodules, subtrees, or copied upstream snapshots.

### Generated runtime skills

Generated Framer project skills are machine-local real directories matching
`$HOME/.agents/skills/framer-project-*`. They remain outside Git. Claude Code
may receive individual compatibility links to those directories.

### Collision and installer safety

- `$HOME/.agents/skills` must be a real directory, never a whole-directory
  symlink into this repository.
- Verify every target and resolved link before writing.
- Refuse real directories, regular files, unexpected symlinks, duplicate
  names, source mismatches, and locally modified CLI-managed contents.
- Preserve a temporary backup outside the repository before reconciling
  ambiguous runtime state.
- `unlink-local` may remove only manifest-owned local symlinks.
- Third-party license and attribution changes must be reviewed when sources
  or selected skills change.

## Editing Conventions

- Preserve comments, grouping, and warning text unless wrong or stale.
- Keep direct shortcuts in `zsh/.oh-my-zsh/custom/aliases.zsh`.
- Keep argument-heavy or safety-sensitive workflows in
  `zsh/.oh-my-zsh/custom/functions.zsh`.
- Keep completions in `zsh/.oh-my-zsh/custom/completions.zsh`.
- Keep universal environment variables minimal in `zsh/.zshenv`.
- Keep login-shell PATH/toolchain setup in `zsh/.zprofile`.
- Keep interactive shell setup in `zsh/.zshrc`.
- Prefer `$HOME` to hard-coded user paths in reusable documentation.

## Package Notes

### `agents`

- Every local skill needs `SKILL.md` with non-empty `name` and `description`.
- Keep `agents/README.md`, `agents/SKILLS_REGISTRY.md`, and
  `agents/THIRD_PARTY.md` current when skills change.
- Use `scripts/agent-skills plan` for read-only inspection.
- Run `scripts/agent-skills install` or `update` only with implementation or
  update authority.
- Never edit third-party runtime contents as though they were tracked source.

### `zsh`

- Before adding a helper name, use `namecheck <name>` when available.
- Before removing or renaming an established shortcut, use
  `usedcount <name>` when available.
- Treat cleanup helpers, Docker volume removal, branch deletion, and
  `git add .` workflows as risky.

### `Brewfile`

- Keep Homebrew changes in `Brewfile`.
- Prefer `bdump`, `brewadd`, and `brewrm` in a shell with these dotfiles.
- Do not run `brewup` automatically.

### `macos/finder`

- Keep Finder automation idempotent and backup-oriented.
- Do not run it unless explicitly requested.

## Verification

Run checks matching the files touched:

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin \
  zsh/.oh-my-zsh/custom/aliases.zsh \
  zsh/.oh-my-zsh/custom/functions.zsh \
  zsh/.oh-my-zsh/custom/completions.zsh
stow --simulate --verbose zsh tmux git starship
scripts/agent-skills plan
scripts/agent-skills status
brew bundle check --file=./Brewfile
```

For Stow changes, always run the simulation before recommending or applying
the real operation.

## Reporting

Final responses should state:

- files created, modified, moved, removed, and symlinked
- runtime changes and preserved backup paths
- validation commands and results
- current Git status
- risks, skipped checks, or follow-ups
- a suggested commit message when useful
