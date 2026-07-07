# AGENTS.md

Canonical instructions for Codex, Claude Code, and other AI agents working in
this dotfiles repository.

## Repository purpose

This personal macOS/Linux dotfiles repository tracks:

- shell startup files and Oh My Zsh customizations
- tmux, global Git, and Starship configuration
- Homebrew package state in `Brewfile`
- Git-vendored local, forked, and approved third-party agent skills
- optional macOS preference automation

GNU Stow manages the `zsh`, `tmux`, `git`, `starship`, and `agents` packages.
The `agents` package always requires `--no-folding`.

New-machine setup and detailed commands belong in `README.md` and
`agents/README.md`.

## Working rules

- Inspect repository structure, relevant files, and
  `git status --short --untracked-files=all` before modifying anything.
- State a short plan before non-trivial changes.
- Preserve all pre-existing unrelated changes.
- Keep changes small, scoped, and reviewable.
- Keep commands concise and copy-pasteable.
- Inspect a real home-directory entry and its resolved target before
  replacing it.
- Do not run broad, destructive, or cleanup commands unless explicitly
  requested.
- Never commit secrets, keys, tokens, credentials, `.env` files, databases,
  logs, caches, `.DS_Store`, generated Framer state, or machine-only
  configuration.

## Authority boundaries

Treat these as separate permissions:

- audit or report
- edit tracked repository files
- run an installer or updater
- apply or remove Stow links
- stage
- commit
- push
- deploy or publish externally

An audit-only request authorizes read-only inspection, not implementation.
Editing does not authorize installation, Stow, staging, committing, pushing,
deployment, or external updates.

## Stow packages

- `zsh`: shell startup and Oh My Zsh custom files
- `tmux`: `$HOME/.tmux.conf`
- `git`: `$HOME/.gitconfig`
- `starship`: `$HOME/.config/starship.toml`
- `agents`: tracked skills and static Claude compatibility links

Always simulate before applying. Use `stow --no-folding` for `agents` so
`$HOME/.agents/skills` and `$HOME/.claude/skills` remain real directories.
Do not use `--adopt` without explicit intent to import existing home contents.

`macos/finder` is optional preference automation, not a Stow package. Do not
run it unless explicitly requested.

## Skill ownership

### Tracked local skills and forks

Canonical source lives under `agents/.agents/skills/<name>`. Edit only this
repository source. Intentional forks require provenance, license information,
and local-change notes in `agents/THIRD_PARTY.md` and
`agents/SKILLS_REGISTRY.md`.

### Vendored approved third-party skills

Approved third-party contents are also tracked under
`agents/.agents/skills/<name>`. Their sources and explicit allowlists live in
`agents/skills.conf`; `agents/skills-lock.json` records project installer
metadata.

Add or update them only from `dotfiles/agents` with project-scoped
`npx skills@latest add <source>`. Never use `--global`, `-g`, or `--all`.
Select only approved names and review every resulting Git change before
updating documentation or committing. Record the resolved CLI version in the
update report; committed contents are the reproducible artifact.

Do not silently overwrite local skills or forks. Installer removal may leave
stale project-lock entries, which must be reconciled explicitly.

### Claude and Codex

Tracked relative links under `agents/.claude/skills` expose intended skills to
Claude Code without duplicating contents. Codex reads `$HOME/.agents/skills`.
Keep `$HOME/.codex` application-managed and do not vendor system/plugin
skills or create a broad Codex Stow package.

### Generated runtime skills

Real directories matching `$HOME/.agents/skills/framer-project-*` remain
outside Git and may contain private project metadata. Their Claude
compatibility links are runtime-only. Never copy, move, delete, or track
generated project skills during ordinary dotfiles maintenance.

## Editing conventions

- Preserve comments, grouping, and warning text unless wrong or stale.
- Keep direct shortcuts in `zsh/.oh-my-zsh/custom/aliases.zsh`.
- Keep argument-heavy or safety-sensitive workflows in
  `zsh/.oh-my-zsh/custom/functions.zsh`.
- Keep completions in `zsh/.oh-my-zsh/custom/completions.zsh`.
- Keep universal environment variables minimal in `zsh/.zshenv`.
- Keep login-shell PATH/toolchain setup in `zsh/.zprofile`.
- Keep interactive shell setup in `zsh/.zshrc`.
- Prefer `$HOME` over hard-coded user paths in reusable documentation.

## Package notes

### `agents`

- Every tracked skill needs `SKILL.md` with non-empty, matching `name` and
  `description`.
- Keep `agents/README.md`, `agents/SKILLS_REGISTRY.md`,
  `agents/THIRD_PARTY.md`, licenses, and `skills.conf` current.
- Use `scripts/agent-skills status` and `audit` for read-only inspection.
- Run `pre-install` before, and `post-install` after, a separately authorized
  third-party installer operation.
- Keep generated/private patterns outside the package.

### `zsh`

- Before adding a helper name, use `namecheck <name>` when available.
- Before removing or renaming a shortcut, use `usedcount <name>` when
  available.
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
bash -n scripts/agent-skills
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin \
  zsh/.oh-my-zsh/custom/aliases.zsh \
  zsh/.oh-my-zsh/custom/functions.zsh \
  zsh/.oh-my-zsh/custom/completions.zsh
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --verbose zsh tmux git starship
stow --target="$HOME" --simulate --no-folding --verbose agents
brew bundle check --no-upgrade --file=./Brewfile
```

For Stow changes, always run simulation before recommending or applying the
real operation.

## Reporting

Final responses should state:

- files created, modified, moved, removed, and symlinked
- runtime changes and preserved backup paths
- validation commands and results
- current Git status
- risks, skipped checks, or follow-ups
- a suggested commit message when useful
