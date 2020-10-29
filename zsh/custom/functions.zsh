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

# Change directory to the current Finder directory
cdf() {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}