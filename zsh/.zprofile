# ~/.zprofile
# Loaded for login shells.
# Use this file for session-wide PATH and toolchain setup.

# Homebrew (Apple Silicon)
# Adds /opt/homebrew/bin and related paths correctly for this machine.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Flutter
# Git source used by Flutter tooling when needed.
export FLUTTER_GIT_URL="ssh://git@github.com/flutter/flutter.git"

# User-local CLI tools
# Keep personal executables early in PATH.
export PATH="$HOME/.local/bin:$HOME/.gem/bin:$PATH"

# Flutter SDKs
# Prefer FVM-managed Flutter first, then fallback to the direct Flutter install.
export PATH="$HOME/fvm/default/bin:$HOME/flutter/bin:$PATH"

# Android SDK tools
# ANDROID_HOME is defined in ~/.zshenv.
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# JetBrains Toolbox CLI scripts
# Lets you launch JetBrains tools from the terminal.
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# OrbStack shell integration
# Load only if present.
[[ -f "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"
