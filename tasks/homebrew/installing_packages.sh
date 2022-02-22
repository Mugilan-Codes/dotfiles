#!/usr/bin/env bash

brew update
brew upgrade

brew bundle --file $DOTFILES/tasks/homebrew/Brewfile

brew cleanup

bot "Symlinking Brewfile from $DOTFILES/tasks/homebrew/Brewfile to $HOME/Brewfile"
# symlink ./tasks/homebrew/Brewfile to ~/Brewfile
ln -sfn $DOTFILES/tasks/homebrew/Brewfile $HOME/Brewfile