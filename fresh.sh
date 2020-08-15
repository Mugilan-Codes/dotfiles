#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install Oh-My-Zsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

brew upgrade
brew cleanup

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
# mkdir $HOME/Sites

# Make a Directory for storing screenshots and projects
# mkdir -p $HOME/Projects/{Forks,College,Playground,Repos,Personal} $HOME/Pictures/screenshots
mkdir -p $HOME/Pictures/screenshots

mkdir -p $HOME/Projects/{Forks,College,Playground,Repos,Personal}

# Clone Github repositories
# ./clone.sh

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
# rm -rf $HOME/.zshrc
# ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Symlink the Mackup config file to the home directory
# ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos