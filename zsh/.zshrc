# ~/.zshrc
# Loaded for interactive shells.
# Keep shell behavior, prompt, plugins, aliases, functions, and completions here.

# Stop early for non-interactive shells.
[[ $- != *i* ]] && return

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Oh My Zsh updates
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 10

# History
HIST_STAMPS="yyyy-mm-dd"
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Add Docker CLI completions before loading Oh My Zsh.
# Add neatCLI completions in .zfunc
# Oh My Zsh will initialize completions for us.
fpath=("$HOME/.docker/completions" "$HOME/.zfunc" $fpath)

# FNM
# Auto-switch Node.js versions based on .nvmrc / .node-version files.
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
fi

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# Default editor (Change to nvim if neovim is preferred and available)
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Interactive tooling
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Custom aliases, functions, and completions
source "$ZSH/custom/aliases.zsh"
source "$ZSH/custom/functions.zsh"
source "$ZSH/custom/completions.zsh"
