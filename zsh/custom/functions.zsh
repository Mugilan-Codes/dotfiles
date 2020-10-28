# Create a new directory and move into it.
# USAGE: mk <DIRECTORY_NAME> 
# eg. mk test || mk test/test2 
mk() {
  echo "Making $@ directory"
	mkdir -p "$@" && cd "$@"
  echo "Changed into $@ directory"
}

# Check for the Shell startup speed
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# Open man page as PDF
manpdf() {
  man -t "${1}" | open -f -a /System/Applications/Preview.app/
}

brew_update() {
  echo "Update Homebrew (Cask) & packages"
  brew update
  brew upgrade
  brew upgrade --cask
  brew cleanup
  brew doctor
}

npm_update() {
  echo "Update npm & packages"
  npm install npm -g
  npm update -g
}

update_all() {
  echo "Update App Store apps"
  sudo softwareupdate -i -a

  brew_update
  
  npm_update
}