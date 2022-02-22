#!/usr/bin/env bash

brew update

# TODO: locate Brewfile
brew bundle

brew upgrade

brew cleanup