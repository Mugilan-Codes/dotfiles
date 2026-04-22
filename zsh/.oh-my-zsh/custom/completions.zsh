# # Load completions

# [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
# [[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"

# ====== REMOVE ABOVE LINES ======

# ~/.oh-my-zsh/custom/completions.zsh
# Custom completion scripts.
# Keep all non-Oh-My-Zsh completions in one place.

# Tabtab completions
[[ -f "$HOME/.config/tabtab/zsh/__tabtab.zsh" ]] && source "$HOME/.config/tabtab/zsh/__tabtab.zsh"

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Dart CLI completions
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"