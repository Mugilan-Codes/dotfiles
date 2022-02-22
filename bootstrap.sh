#!/usr/bin/env bash

source ./helpers/utility.sh

header "Hi! I'm going to setup your Mac. This will only take a few minutes. \n"

# xcode-select
header "Install xcode-select..."
xcode-select -p > /dev/null
if [[ $? != 0 ]] ; then
  xcode-select --install
fi

export DOTFILES=$HOME/.dotfiles
bot "Setting up dotfiles..."

source ./tasks/homebrew/main.sh

bot "All done!"