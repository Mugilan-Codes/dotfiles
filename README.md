# Dotfiles

Personal Apple Silicon macOS developer setup managed with GNU Stow.

This repository tracks the configuration I use for daily development: zsh, tmux, Git, Starship, Homebrew packages, and local Codex/agent skills. Stow packages live as top-level directories and are symlinked into `$HOME`. Homebrew startup also detects common Intel macOS and Linuxbrew locations, but the Android, Finder, application, and PATH setup is primarily macOS-specific.

## Stow Packages

| Package | Installs To | Purpose |
| --- | --- | --- |
| `zsh` | `$HOME/.zshrc`, `$HOME/.zprofile`, `$HOME/.zshenv`, `$HOME/.zlogin`, `$HOME/.oh-my-zsh/custom/*` | Interactive shell, PATH setup, aliases, functions, completions |
| `tmux` | `$HOME/.tmux.conf` | tmux prefix, panes, navigation, resizing, status bar |
| `git` | `$HOME/.gitconfig` | Global Git config and aliases |
| `starship` | `$HOME/.config/starship.toml` | Prompt configuration |
| `agents` | `$HOME/.agents/skills` | Local Codex/agent skills, guide, and registry |

`macos/finder` is optional macOS preference automation. It is not a Stow package and should be run only when you intentionally want to change Finder defaults.

## Repository Layout

```text
dotfiles/
├── AGENTS.md
├── Brewfile
├── CLAUDE.md
├── CODEX_USAGE.md
├── README.md
├── agents/
│   └── .agents/skills/
├── git/
│   └── .gitconfig
├── macos/finder/
├── starship/
│   └── .config/starship.toml
├── tmux/
│   └── .tmux.conf
└── zsh/
    ├── .zprofile
    ├── .zshenv
    ├── .zshrc
    └── .oh-my-zsh/custom/
```

## New Machine Setup

Install Homebrew, Git, and Stow:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git stow
```

Clone the repo:

```sh
git clone git@github.com:Mugilan-Codes/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Install Oh My Zsh if it is not already present:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the two third-party plugins enabled by `.zshrc`:

```sh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] ||
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] ||
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

If the installer creates a real `~/.zshrc`, back it up before stowing this repo's `zsh` package.

Preview symlinks before applying them:

```sh
stow --simulate --verbose zsh tmux git starship agents
```

Apply the packages:

```sh
stow --verbose zsh tmux git starship agents
```

Install packages from Homebrew:

```sh
brew bundle --file=~/dotfiles/Brewfile
```

The Brewfile grants Homebrew 6 trust only to the named third-party formulae and casks it installs. Do not trust an entire tap unless every current and future item in that tap should be allowed to run.

Restart the shell:

```sh
exec zsh
```

## Stow Usage

Run Stow commands from the repo root.

Preview one package:

```sh
stow --simulate --verbose agents
```

Apply one package:

```sh
stow --verbose agents
```

Preview all packages:

```sh
stow --simulate --verbose zsh tmux git starship agents
```

Restow after edits:

```sh
stow --restow --verbose zsh tmux git starship agents
```

Unstow a package:

```sh
stow --delete --verbose agents
```

If Stow reports that a target already exists, inspect it first. Back up real files before replacing them; do not use `--adopt` unless you intentionally want to absorb existing home-directory files into this repo.

## Verification

Run the relevant checks after changes:

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin zsh/.oh-my-zsh/custom/aliases.zsh zsh/.oh-my-zsh/custom/functions.zsh zsh/.oh-my-zsh/custom/completions.zsh
stow --simulate --verbose zsh tmux git starship agents
brew bundle check --no-upgrade --file=./Brewfile
```

When the dotfiles are already loaded, these helpers are also useful:

```sh
dotdoctor
dotlinks
namecheck newname
usedcount existingname
```

## Daily Maintenance

Common commands from the zsh helpers:

```sh
bdump          # preview local Homebrew state, then confirm Brewfile replacement
brewcheck      # check Brewfile against installed packages
brewtrustcheck # list Homebrew trust state and run brew doctor
brewoutdated   # preview outdated Homebrew packages
dotstow        # simulate, then restow all packages after confirmation
gmsg           # print a Codex-generated message for staged changes
gcai           # generate with Codex, then review and commit staged changes
reload         # reload Oh My Zsh config
rz             # restart zsh
rzl            # restart login zsh
```

Use aliases for direct shortcuts and functions for workflows that need arguments, checks, confirmations, branching, or multiple commands.

## Backups And Rollback

Before applying Stow on a new machine, back up any existing files that would be replaced, especially shell startup files, `.gitconfig`, `.tmux.conf`, and Starship config.

Rollback options:

```sh
stow --delete --verbose zsh tmux git starship agents
```

This removes Stow-managed symlinks; it does not revert repository edits. Review `git diff` and restore individual repository files only when you intentionally want to discard those changes. Do not remove real home-directory files unless you know whether they are symlinks created by Stow or independent files you still need.

## Safety Notes

- `.gitconfig` supports multiple identities with `includeIf`.
- `gcommit` stages all changes and pushes; prefer staged workflows when reviewing changes.
- `brewdump` generates a temporary snapshot and requires confirmation before replacing Brewfile.
- `brewsave` refuses unrelated staged files and commits only Brewfile; `brewpush` never pushes automatically.
- `brewup` can upgrade many tools at once.
- Docker cleanup helpers can remove local data, especially volumes.
- Generated `agents/.agents/skills/framer-project-*` folders can contain private project metadata and must remain local-only.
- `macos/finder/setup-finder.sh` changes macOS preferences and should be run intentionally.
- `.DS_Store`, swap files, `.env`, secrets, keys, tokens, and local-only files should stay out of Git.
