#!/usr/bin/env bash

running "Checking homebrew..."

brew_bin=$(which brew) 2>&1 > /dev/null

if [[ $? != 0 ]]; then
  action "Installing homebrew..."
  # Unattended installation of Homebrew
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  # warn "Homebrew already exists."
  ok
fi