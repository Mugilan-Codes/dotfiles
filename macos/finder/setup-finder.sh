#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This Finder setup script only runs on macOS." >&2
  exit 1
fi

for required_command in defaults killall open date cp mkdir; do
  if ! command -v "$required_command" >/dev/null 2>&1; then
    echo "Missing required command: $required_command" >&2
    exit 1
  fi
done

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_root="$HOME/Desktop/.desktop-files/finder-settings"
backup_dir="$backup_root/backup-$timestamp"
screenshot_dir="$HOME/Desktop/.desktop-files/screenshots"

if [[ -e "$backup_dir" ]]; then
  suffix=1
  while [[ -e "$backup_dir-$suffix" ]]; do
    ((suffix += 1))
  done
  backup_dir="$backup_dir-$suffix"
fi

backup_file() {
  local source_file="$1"

  if [[ -e "$source_file" || -L "$source_file" ]]; then
    cp -p "$source_file" "$backup_dir/"
    echo "  backed up: $source_file"
  else
    echo "  not present: $source_file"
  fi
}

restart_service() {
  local service_name="$1"

  echo "Restarting $service_name ..."
  killall "$service_name" >/dev/null 2>&1 || true
}

echo "Creating Finder settings backup directory:"
echo "  $backup_dir"
mkdir -p "$backup_dir"

echo "Backing up current preference files when present ..."
backup_file "$HOME/Library/Preferences/com.apple.finder.plist"
backup_file "$HOME/Library/Preferences/.GlobalPreferences.plist"
backup_file "$HOME/Library/Preferences/com.apple.sidebarlists.plist"
backup_file "$HOME/Library/Preferences/com.apple.desktopservices.plist"
backup_file "$HOME/Library/Preferences/com.apple.screencapture.plist"

echo "Creating screenshot directory:"
echo "  $screenshot_dir"
mkdir -p "$screenshot_dir"

echo "Applying global macOS defaults ..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Applying Finder defaults ..."
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder FinderSpawnTab -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool true
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Development/"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder AppleShowAllFiles -bool false

echo "Disabling .DS_Store writes on network and USB volumes ..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Setting screenshot location ..."
defaults write com.apple.screencapture location -string "$screenshot_dir"

echo "Restarting affected services so changes take effect ..."
restart_service cfprefsd
restart_service SystemUIServer
restart_service Finder

echo "Opening Finder ..."
open -a Finder

echo "Finder setup complete."
echo "Backup saved at:"
echo "  $backup_dir"
