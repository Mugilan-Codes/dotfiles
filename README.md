# Dotfiles

Personal macOS development environment setup using **zsh + tmux + Homebrew + stow**.

This repo recreates my daily shell, terminal, Git, Homebrew, tmux, Starship, and CLI workflow on macOS.

---

## Includes

### Shell (zsh)

- `.zshrc`, `.zprofile`, `.zshenv`, `.zlogin`
- Oh My Zsh with custom:
  - aliases
  - functions
  - completions

### Terminal Workflow

- `tmux` configuration (vim-style navigation, smart splits, session workflow)

### Git

- global `.gitconfig`
- work/personal separation support

### Package Management

- `Brewfile` (Homebrew formulas, casks, taps)

### Prompt

- `starship` configuration

---

## Structure

```
dotfiles/
├── Brewfile
├── git/
│   └── .gitconfig
├── starship/
│   └── .config/starship.toml
├── tmux/
│   └── .tmux.conf
├── zsh/
│   ├── .zshrc
│   ├── .zprofile
│   ├── .zshenv
│   ├── .zlogin
│   └── .oh-my-zsh/custom/
│       ├── aliases.zsh
│       ├── functions.zsh
│       └── completions.zsh
```

---

## New Mac Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

### 2. Install Git

```bash
brew install git
```

---

### 3. Clone this repo

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

### 4. Install Stow

```bash
brew install stow
```

---

### 5. Apply dotfiles with GNU Stow

```bash
stow zsh
stow tmux
stow git
stow starship
```

Run these from `~/dotfiles`. Stow creates symlinks into your home directory.
If a target file already exists, move or back it up before stowing.

---

### 6. Install all tools from Brewfile

```bash
brew bundle --file=~/dotfiles/Brewfile
```

---

### 7. Install Oh My Zsh (if not already)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

### 8. Restart shell

```bash
exec zsh
```

---

## Daily Workflow Cheatsheet

### Navigation

```bash
zz        # jump to recent/frequent directories
cdf       # fuzzy-pick a directory under the current path
finder    # cd into the frontmost Finder window
cdp       # jump to ~/Projects
```

### Search

```bash
fdf       # real fd file search
fo        # fuzzy-open a file
searchf   # search file contents, then open a match
fgl       # live ripgrep search with fzf
```

### tmux

```bash
tm         # pick or create a tmux session
sessionize # open a zoxide project as a tmux session
tmuxdev    # create a 3-pane dev session
```

### Git

```bash
gmsg       # generate commit message from staged changes
gci        # generate message and commit after confirmation
gcai       # alias for gci
gclean     # interactively delete merged local branches
git lg     # graph log
git ds     # staged diff
git save "message"  # stash with a message
```

### Brew

```bash
brewadd jq        # install and refresh Brewfile
brewrm jq         # uninstall and refresh Brewfile
bdump             # refresh Brewfile
bsave             # refresh and commit Brewfile if changed
bpush             # refresh, commit, and push Brewfile if changed
brewup            # update/upgrade/cleanup Homebrew packages
```

### Docker / OrbStack

```bash
ostatus           # check OrbStack status
ostart            # start OrbStack
ostop             # stop OrbStack
dctx              # show Docker contexts
dcu               # docker compose up -d
dcd               # docker compose down
dcdv              # docker compose down -v after confirmation
dvprune           # prune Docker volumes after confirmation
docker-health     # full OrbStack + Docker health check
docker-clean-safe # prune Docker without volumes
```

### Cleanup

```bash
trashsize         # show Trash size
emptytrash        # permanently empty Trash after confirmation
cleanmac          # remove user cache files after confirmation
cleanderived      # remove Xcode DerivedData after confirmation
cleanfluttercache # clean Flutter/Dart caches after confirmation
dlclean           # preview Downloads organization
dlgo              # organize Downloads after confirmation
dlold             # preview old Downloads cleanup
dloldgo           # move old Downloads files to Trash after confirmation
```

### Dotfiles Maintenance

```bash
aliases           # edit aliases
zfunctions        # edit functions
completions       # edit completions
showpath          # print PATH one entry per line
reload            # reload Oh My Zsh
rz                # restart zsh
rzl               # restart login zsh
namecheck dcu     # check whether a name is already used
usedcount dcu     # estimate command usage from zsh history
```

---

## Homebrew Workflow

### Install / Remove packages

```bash
brewadd jq
brewadd --cask docker
brewrm jq
```

### Update Brewfile

```bash
bdump
```

### Save to git

```bash
bsave
bsave "Update Brewfile"
```

### Update installed packages

```bash
brewup
```

`brewup` upgrades installed formulae/casks and cleans old versions. Run it intentionally, not right before important work.

---

## Reloading zsh

```bash
reload   # reload Oh My Zsh config
rz       # restart normal zsh
rzl      # restart login zsh after editing .zprofile or .zlogin
```

Use `rzl` after changing login-shell setup like PATH entries in `.zprofile`.

---

## Safety Notes

- `C-Space` is used as tmux prefix (change if needed)
- `.gitconfig` supports multiple identities via `includeIf`
- `fdart` runs `fvm dart`; the real `fd` command is left unshadowed
- `dcdv`, `dvprune`, `emptytrash`, `cleanmac`, `cleanderived`, and `cleanfluttercache` require confirmation
- `gcommit` runs `git add .`, commits, and pushes; prefer staged workflows with `gmsg` / `gci` when you need review
- Docker volume cleanup can delete local database data
- `brewup` can upgrade many tools at once

---

## Adding Aliases and Functions Safely

Before adding a new name:

```bash
namecheck newname
```

Use aliases for short, direct command shortcuts. Use functions when a helper needs arguments, branching, confirmation, file deletion, Git changes, or multiple commands.

Keep names clear and avoid shadowing common tools like `test`, `fd`, `fg`, `dc`, or shell builtins unless there is a strong reason.

---

## Updating Dotfiles

```bash
cd ~/dotfiles
git pull
stow zsh tmux git starship
exec zsh
```

---

## Cleanup (optional)

```bash
cleanbrew
cleannpm
cleanyarn
cleanfluttercache
```

Cleanup helpers vary in risk. Preview-first helpers like `dlclean` are safest; deletion/cache cleanup helpers print warnings or ask for confirmation.

---

## Philosophy

- Keep it minimal but powerful
- Prefer functions over complex aliases
- Avoid destructive automation
- Optimize for real daily usage

---

## Status

This setup is stable and ready for daily development use.
