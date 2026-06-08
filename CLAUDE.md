# CLAUDE.md

Claude-specific guidance for working in this dotfiles repository.

## Safe Review Flow

1. Inspect the repo structure and identify the affected Stow package.
2. Check `git status --short --untracked-files=all` before editing.
3. Propose a short plan for non-trivial changes.
4. Modify only the scoped files needed for the task.
5. Run relevant verification, especially `stow --simulate --verbose ...` for Stow changes.
6. Summarize the diff, Git status, checks run, and any risks.

## Repository Model

This repo uses GNU Stow. Top-level package directories mirror paths under `$HOME`.

- `zsh` manages shell startup files and Oh My Zsh customizations.
- `tmux` manages `$HOME/.tmux.conf`.
- `git` manages `$HOME/.gitconfig`.
- `starship` manages `$HOME/.config/starship.toml`.
- `agents` manages `$HOME/.agents/skills`.

`macos/finder` is optional Finder preference automation, not a Stow package.

## Guardrails

- Do not alter unrelated packages.
- Do not replace real home-directory files blindly.
- Do not run destructive cleanup, package upgrades, Git staging, commits, pushes, or real Stow operations unless requested.
- Do not commit `.DS_Store`, `.env`, secrets, keys, tokens, swap files, temporary files, or machine-only config.
- Keep docs concise and commands copy-pasteable.
- Prefer `$HOME/.agents/skills` in reusable skills documentation instead of hard-coded `/Users/mugilan/.agents/skills`.

## Useful Checks

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
stow --simulate --verbose agents
stow --simulate --verbose zsh tmux git starship agents
```

For zsh edits, also run:

```sh
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin zsh/.oh-my-zsh/custom/aliases.zsh zsh/.oh-my-zsh/custom/functions.zsh zsh/.oh-my-zsh/custom/completions.zsh
```
