#!/usr/bin/env bash

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
