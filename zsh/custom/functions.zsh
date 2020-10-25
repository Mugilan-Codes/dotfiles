# Create a new directory and moves into it.
# USAGE: mkd <DIRECTORY_NAME> 
# eg. mkd test || mkd test/test2 
mkd() {
	mkdir -p "$@" && cd "$@"
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}