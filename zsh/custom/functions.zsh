# Create a new directory and moves into it.
# USAGE: mkd <DIRECTORY_NAME> 
# eg. mkd test || mkd test/test2 
mkd() {
	mkdir -p "$@" && cd "$@"
}