#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew recipes
brew update

echo "Installing Brew Files..."
# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

brew upgrade
brew cleanup

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