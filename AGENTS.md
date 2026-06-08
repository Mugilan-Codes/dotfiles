# AGENTS.md

Instructions for Codex and other AI agents working in this dotfiles repository.

## Repository Purpose

This is a personal macOS/Linux dotfiles repo. It uses GNU Stow to symlink package directories into `$HOME` and tracks:

- shell startup files and Oh My Zsh customizations
- tmux configuration
- global Git configuration
- Starship prompt configuration
- Homebrew package state in `Brewfile`
- local Codex/agent skills under `agents/.agents/skills`

There is no single bootstrap script. New-machine setup is documented in `README.md`.

## Current Stow Packages

- `zsh`: `.zshrc`, `.zprofile`, `.zshenv`, `.zlogin`, Oh My Zsh custom aliases/functions/completions
- `tmux`: `.tmux.conf`
- `git`: `.gitconfig`
- `starship`: `.config/starship.toml`
- `agents`: `.agents/skills`

`macos/finder` is optional macOS preference automation and is not a Stow package.

## Working Rules

- Inspect before modifying: start with repo structure, relevant files, and `git status --short --untracked-files=all`.
- Keep changes small, scoped, and reviewable.
- Preserve the existing package structure. New home-directory files should live under the right Stow package path.
- Do not alter unrelated packages while fixing docs or one package.
- Do not overwrite real home-directory files. If a Stow target already exists and is not a symlink, stop and report it.
- Do not run broad or destructive commands unless explicitly requested.
- Do not commit, stage, push, restow, upgrade Homebrew packages, or run cleanup helpers unless explicitly asked.
- Do not commit secrets, API keys, tokens, SSH keys, private credentials, `.env` files, `.DS_Store`, swap files, temporary files, or machine-only local config.

## Editing Conventions

- Preserve comments, grouping, and warning text unless they are wrong or stale.
- Keep direct shortcuts in `zsh/.oh-my-zsh/custom/aliases.zsh`.
- Keep argument-heavy or safety-sensitive workflows in `zsh/.oh-my-zsh/custom/functions.zsh`.
- Keep completions in `zsh/.oh-my-zsh/custom/completions.zsh`.
- Keep universal environment variables minimal in `zsh/.zshenv`.
- Keep login-shell PATH/toolchain setup in `zsh/.zprofile`.
- Keep interactive shell setup in `zsh/.zshrc`.
- For reusable docs, prefer `$HOME` over hard-coded `/Users/mugilan` paths unless the absolute path is intentionally shown as a machine-specific example or historical note.

## Package Notes

### `agents`

- The `agents` Stow package manages `$HOME/.agents/skills`.
- Skill folders live under `agents/.agents/skills/<skill-name>/`.
- Each skill folder should contain a `SKILL.md` with non-empty `name` and `description` frontmatter.
- Keep `agents/.agents/skills/SKILLS_GUIDE.md` and `agents/.agents/skills/SKILLS_REGISTRY.md` updated when skills are added, removed, renamed, or materially changed.
- Ignore and remove local junk such as `.DS_Store`; do not include it in the package.

### `zsh`

- Before adding a helper name, use `namecheck <name>` when available.
- Before removing or renaming an established shortcut, use `usedcount <name>` when available.
- Treat cleanup helpers, Docker volume removal, branch deletion, and `git add .` workflows as risky.

### `Brewfile`

- Keep Homebrew changes in `Brewfile`.
- Prefer existing helpers such as `bdump`, `brewadd`, and `brewrm` when working from a shell where these dotfiles are loaded.
- Do not run `brewup` automatically.

### `macos/finder`

- Treat Finder setup as scoped preference automation.
- Keep it idempotent and backup-oriented.
- Do not run it unless explicitly requested.

## Verification

Run checks that match the files touched:

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin zsh/.oh-my-zsh/custom/aliases.zsh zsh/.oh-my-zsh/custom/functions.zsh zsh/.oh-my-zsh/custom/completions.zsh
stow --simulate --verbose agents
stow --simulate --verbose zsh tmux git starship agents
brew bundle check --file=./Brewfile
```

For Stow changes, always run `stow --simulate --verbose ...` before recommending or applying real Stow operations.

## Reporting

Final responses should mention:

- files created, modified, and removed
- validation commands run and their results
- current Git status
- risks, skipped checks, or follow-ups
- suggested commit message when useful
