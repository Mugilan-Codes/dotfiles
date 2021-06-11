# Removes Homebrew warning
# export PATH="/usr/local/sbin:$PATH"

# Change `grep` path to use homebrew installed version
export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"

# Use brew installed `git`
export PATH="/usr/local/sbin:$PATH"

# Load Node global installed binaries
# REF: NVM global node_modules - https://github.com/nvm-sh/nvm/issues/2023#issuecomment-543662074
# export PATH="$(npm config get prefix)/lib/node_modules"
# export PATH="$(npm root -g)"
# TODO: rewrite this as NVM is used
export PATH="$HOME/.node/bin:$PATH"

# Use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"

# React Native Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# REF: Remove Duplicates in PATH - https://superuser.com/a/1321712
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"