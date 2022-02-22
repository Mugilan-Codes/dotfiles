#! /bin/sh

header "Setting up Git"
source ./git/git-setup.sh

echo "Making Working Directories..."
# Make a Directory for storing screenshots
mkdir -p $HOME/Pictures/screenshots

# Download Dracula and Shades-of-Purple Color Scheme for Iterm2
ITERM_COLOR_SCHEME_LOCATION=$HOME/Documents/Iterm2/Schemes

mkdir -p $ITERM_COLOR_SCHEME_LOCATION

ITERM_COLOR_SCHEME_NAME=shades-of-purple
curl -o $ITERM_COLOR_SCHEME_LOCATION/$ITERM_COLOR_SCHEME_NAME.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/$ITERM_COLOR_SCHEME_NAME.itermcolors

curl -o $ITERM_COLOR_SCHEME_LOCATION/Dracula.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Dracula.itermcolors

header "ZSH Setup"
source ./zsh/zsh_setup.sh

header "Creating folders for GO development"
test -d "${GOPATH}" || mkdir "${GOPATH}"
# mkdir -p "${GOPATH}/{bin,src,pkg}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

# Symlink the Mackup config file to the home directory
rm -rf $HOME/.mackup.cfg
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg

echo "Setting Up macOS Defaults..."
# Set macOS preferences
# We will run this last because this will reload the shell
source .macos