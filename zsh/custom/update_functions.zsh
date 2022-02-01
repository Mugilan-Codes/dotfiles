brew_update() {
  echo "Update Homebrew (Cask) & packages"
  brew update
  brew upgrade
  # brew upgrade --cask
  brew cleanup
  brew doctor
}

# FIXME: Upgrading typescript@next to latest typescript when using this
npm_update() {
  echo "Update npm & packages"
  npm install npm -g
  npm update -g
}

update_all() {
  echo "Update App Store apps"
  sudo softwareupdate -i -a

  brew_update
  
  # npm_update
}