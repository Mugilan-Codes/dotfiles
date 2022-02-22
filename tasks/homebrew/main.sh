#!/usr/bin/env bash

# REF: Homebrew - https://brew.sh/
bot "Setting up Homebrew..."

source ./tasks/homebrew/installing_homebrew.sh
source ./tasks/homebrew/installing_packages.sh

bot "Symlinking Brewfile from $DOTFILES/tasks/homebrew/Brewfile to $HOME/Brewfile"
# symlink ./tasks/homebrew/Brewfile to ~/Brewfile
ln -sfn $DOTFILES/tasks/homebrew/Brewfile $HOME/Brewfile