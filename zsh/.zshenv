# # ─────────────────────────────────────────────
# # ✅ Minimal critical environment config
# # Loaded by ALL shells (login or not)
# # ─────────────────────────────────────────────

# # ─ Language / Locale ─
# export LANG="en_US.UTF-8"

# # ─ Flutter (default and FVM) ─
# export FLUTTER_GIT_URL="ssh://git@github.com/flutter/flutter.git"
# export PATH="$HOME/flutter/bin:$PATH"
# export PATH="$HOME/fvm/default/bin:$PATH"

# # ─ Local CLI tools ─
# # cocoapods for flutter
# export PATH="$HOME/.gem/bin:$PATH"
# export PATH="$HOME/.local/bin:$PATH"

# # ─ Android SDK ─
# export ANDROID_HOME="$HOME/Library/Android/sdk"
# export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# ====== REMOVE ABOVE LINES ======

# ~/.zshenv
# Loaded by every zsh process: interactive, login, non-interactive, and subshells.
# Keep this file minimal. Only universal environment variables belong here.

# Locale
export LANG="en_US.UTF-8"

# Android SDK root
# PATH entries using ANDROID_HOME are set in ~/.zprofile.
export ANDROID_HOME="$HOME/Library/Android/sdk"