# ~/.oh-my-zsh/custom/completions.zsh
# Custom completion scripts.
# Keep all non-Oh-My-Zsh completions in one place.

# Tabtab completions
[[ -f "$HOME/.config/tabtab/zsh/__tabtab.zsh" ]] && source "$HOME/.config/tabtab/zsh/__tabtab.zsh"

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Dart CLI completions
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"

# Mole shell completion
() {
  local output
  if command -v mole >/dev/null 2>&1 && output="$(mole completion zsh 2>/dev/null)"; then
    eval "$output"
  fi
}
