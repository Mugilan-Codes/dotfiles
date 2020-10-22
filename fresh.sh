#! /bin/sh

header() {
  echo "$(tput sgr 0 1)$(tput setaf 6)$1$(tput sgr0)"
}

header "Setting up Mugilan's Mac..."

header "Homebrew"
source ./homebrew/brew.sh

header "Oh-My-Zsh"
if [ ! -e ~/.oh-my-zsh ]; then
  echo "Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh-My-Zsh installation is skipped"
fi

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
# mkdir $HOME/Sites

echo "Making Working Directories..."
# Make a Directory for storing screenshots
mkdir -p $HOME/Pictures/screenshots

# Download Dracula and Shades-of-Purple Color Scheme for Iterm2
ITERM_COLOR_SCHEME_LOCATION=$HOME/Documents/Iterm2/Schemes

mkdir -p $ITERM_COLOR_SCHEME_LOCATION

ITERM_COLOR_SCHEME_NAME=shades-of-purple
curl -o $ITERM_COLOR_SCHEME_LOCATION/$ITERM_COLOR_SCHEME_NAME.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/$ITERM_COLOR_SCHEME_NAME.itermcolors

curl -o $ITERM_COLOR_SCHEME_LOCATION/Dracula.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Dracula.itermcolors

# Set Project Directories & Clone Github repositories
./clone.sh

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
# rm -rf $HOME/.zshrc
# ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Symlink the Mackup config file to the home directory
# ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

echo "Setting Up macOS Defaults..."
# Set macOS preferences
# We will run this last because this will reload the shell
source .macos