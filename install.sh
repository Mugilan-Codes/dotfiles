#!/bin/bash
# Apple Silicon bootstrap. Never source the user's shell configuration.
set -eu
set -o pipefail
ROOT="$(cd "$(dirname "$0")" && pwd -P)"
export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_UPGRADE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_INSTALL_CLEANUP=1
mode=install
target="$HOME"
isolated=0
restore=0
# Validate the entire interface before any package action.
original_arg_count=$#
args=("$@")
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run|--check)
      [[ "$mode" == install ]] || { echo 'Choose one mode.' >&2; exit 2; }
      [[ "$1" == --dry-run ]] && mode=dry || mode=check
      shift ;;
    --target)
      [[ $# -ge 2 && -n "$2" ]] || { echo '--target requires a directory' >&2; exit 2; }
      isolated=1; shift 2 ;;
    --backup) shift ;;
    --restore)
      [[ $# -eq 2 && $original_arg_count -eq 2 ]] || { echo '--restore requires only a record path' >&2; exit 2; }
      restore=1; isolated=1; shift 2 ;;
    --help|-h)
      echo 'Usage: ./install.sh [--dry-run|--check] [--target DIR] [--backup]'
      echo '       ./install.sh --restore /absolute/path/to/restore.json'
      exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
if [[ "$original_arg_count" -gt 0 ]]; then
  set -- "${args[@]}"
else
  set --
fi
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  echo 'Unsupported platform: this installer is verified for Apple Silicon macOS only.' >&2
  exit 2
fi
if [[ -n "${CODEX_HOME:-}" && "$CODEX_HOME" != "$HOME/.codex" && "$isolated" == 0 ]]; then
  echo 'Nondefault CODEX_HOME: use selective deployment in docs/RECOVERY.md; refusing the wrong instruction destination.' >&2
  exit 2
fi
if [[ "$mode" == dry ]]; then
  echo 'DRY RUN: no downloads, packages, directories, backups, or links will be created.'
fi
if [[ "$isolated" == 0 ]]; then
  if ! /usr/bin/xcode-select -p >/dev/null 2>&1; then
    echo 'MANUAL: run xcode-select --install, finish the macOS prompt, then rerun ./install.sh.'
    [[ "$mode" == dry ]] && exit 0 || exit 2
  fi
  if [[ ! -x /opt/homebrew/bin/brew ]]; then
    echo 'MANUAL: install Homebrew using https://brew.sh, then rerun ./install.sh.'
    [[ "$mode" == dry ]] && exit 0 || exit 2
  fi
  missing=0
  while IFS= read -r package; do
    [[ -n "$package" ]] || continue
    if [[ -d "/opt/homebrew/opt/$package" ]]; then
      echo "COMPLETED: $package"
    elif [[ "$mode" == install ]]; then
      /opt/homebrew/bin/brew install --formula "$package" || { echo "FAILED: $package" >&2; exit 1; }
    else
      echo "MISSING: $package"
      missing=1
    fi
  done < <(/usr/bin/sed -n 's/^brew "\([^"]*\)".*/\1/p' "$ROOT/Brewfile.core")
  [[ "$mode" != check || "$missing" == 0 ]] || exit 1
fi
python=/opt/homebrew/bin/python3
if [[ ! -x "$python" ]]; then
  echo 'MANUAL: Python 3 is required for deployment checks; normal installation provisions it from Brewfile.core.'
  [[ "$mode" == dry ]] && exit 0 || exit 2
fi
exec "$python" -B "$ROOT/scripts/deploy.py" "$@"
