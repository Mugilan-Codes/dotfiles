update_brew() {
  # TODO: use Brewfile and `brew bundle` to update
  header "Update Homebrew (Cask) & packages"
  # brew bundle -v
  brew update
  brew upgrade
  # brew upgrade --cask
  brew cleanup
  brew doctor --verbose
}

# FIXME: Upgrading typescript@next to latest typescript when using this
# using pnpm
npm_update() {
  header "Update npm & packages"
  npm install npm -g
  npm update -g
}

update_all() {
  header "Update App Store apps"
  # sudo softwareupdate -ia —verbose ; brew bundle -v ; brew cleanup ; brew doctor —verbose

  # Isnall All appropriate updates
  sudo softwareupdate --install --all --verbose

  update_brew
}

# Helper utility
header() {
  echo "$(tput sgr 0 1)$(tput setaf 6)$1$(tput sgr0)"
}