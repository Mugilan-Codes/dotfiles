# 🛠 Dotfiles

Personal macOS development environment setup using **zsh + tmux + Homebrew + stow**.

This repo allows you to fully recreate your shell, terminal, and tooling setup on a new Mac in minutes.

---

## 📦 Includes

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

## 📁 Structure

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

## 🚀 New Mac Setup (Step-by-step)

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

### 5. Apply dotfiles (symlinks)

```bash
stow zsh
stow tmux
stow git
stow starship
```

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

## ⚡ Daily Workflow Helpers

### Navigation

```bash
zz
cdf
finder
```

### Search

```bash
fo
fg
searchf
```

### tmux

```bash
tm
sessionize
tmuxdev
```

### System

```bash
bt
topmem
topcpu
```

---

## 🍺 Homebrew Workflow

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

---

## 🧠 Key Features

- Reproducible dev environment
- Clean alias/function separation
- fzf-powered navigation + search
- tmux-based workflow
- Automated Brewfile sync
- Modular dotfiles (via stow)

---

## ⚠️ Notes

- `C-Space` is used as tmux prefix (change if needed)
- `.gitconfig` supports multiple identities via `includeIf`
- `fd` is aliased to `fvm dart`, so internal usage uses `command fd`

---

## 🔄 Updating Dotfiles

```bash
cd ~/dotfiles
git pull
stow zsh tmux git starship
exec zsh
```

---

## 🧹 Cleanup (optional)

```bash
cleanbrew
cleannpm
cleanyarn
cleanfluttercache
```

---

## 📌 Philosophy

- Keep it minimal but powerful
- Prefer functions over complex aliases
- Avoid destructive automation
- Optimize for real daily usage

---

## ✅ Status

This setup is stable and ready for daily development use.
