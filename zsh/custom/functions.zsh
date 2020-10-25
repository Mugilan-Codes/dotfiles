# Create a new directory and move into it.
# USAGE: mk <DIRECTORY_NAME> 
# eg. mk test || mk test/test2 
mk() {
	mkdir -p "$@" && cd "$@"
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

update_all() {
  # Update App Store apps
  sudo softwareupdate -i -a
  # Update Homebrew (Cask) & packages
  brew update
  brew upgrade
  # Update npm & packages
  npm install npm -g
  npm update -g
}