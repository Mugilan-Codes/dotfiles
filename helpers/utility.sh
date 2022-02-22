#!/usr/bin/env bash

# Color Codes & Custom utilities
# REF: BASH SHELL SCRIPTING UTILITIES - http://natelandau.com/bash-scripting-utilities/

## Fonts
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

## Colors
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

## To check input is empty or not
is_empty() {
if [ $# -eq  0 ]
  then
    return 1
fi
  return 0
}

## To check programs exit or not
is_exists() {
if [ $(type -P $1) ]; then
  return 1
fi
  return 0
}

## To check file exits or not
is_file_exists() {
if [ -f "$file" ]
then
	return 1
else
	return 0
fi
}

# Custom echo functions

ask() {
  printf "\n${bold}$@${reset}"
}

e_thanks() {
  printf "\n${bold}${purple}$@${reset}\n"
}

e_header() {
  printf "\n${underline}${bold}${green}%s${reset}\n" "$@"
}

e_arrow() {
  printf "\n ᐅ $@\n"
}

e_success() {
  printf "\n${green}✔ %s${reset}\n" "$@"
}

e_error() {
  printf "\n${red}✖ %s${reset}\n" "$@"
}

e_warning() {
  printf "\n${tan}ᐅ %s${reset}\n" "$@"
}

e_underline() {
  printf "\n${underline}${bold}%s${reset}\n" "$@"
}

e_bold() {
  printf "\n${bold}%s${reset}\n" "$@"
}

e_note() {
  printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

## End
# =========== Custom Echos ===========

header() {
  echo "$(tput sgr 0 1)$(tput setaf 6)$1$(tput sgr0)"
}

ESQ_SEQ="\x1b["
COL_RESET="${ESQ_SEQ}39;49;00m"
COL_GREEN="${ESQ_SEQ}32;01m"
COL_YELLOW="${ESQ_SEQ}33;01m"
COL_RED="${ESQ_SEQ}31;01m"

function ok() {
  echo -e "${COL_GREEN}[ok]${COL_RESET} "$1
}

function bot() {
  echo -e $1
}

function running() {
  echo -en "${COL_YELLOW} => ${COL_RESET} "$1": "
}

function action() {
  echo -e "\n${COL_YELLOW}[action]:${COL_RESET}\n => $1..."
}

function warn() {
  echo -e "${COL_YELLOW}[warning]${COL_RESET} "$1
}

function error() {
  echo -e "${COL_RED}[error]${COL_RESET} "$1
}