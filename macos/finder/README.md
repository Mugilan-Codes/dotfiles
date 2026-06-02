# Finder Setup

This directory contains a safe, repeatable macOS Finder preference setup script.

## What It Changes

`setup-finder.sh` applies these defaults:

- shows all filename extensions
- expands save and print dialogs
- shows the Finder path bar, status bar, and tab bar
- prefers List View for new Finder windows
- searches the current folder by default
- keeps folders on top when sorting by name
- keeps folders on top on the Desktop
- keeps the extension change warning enabled for safety
- keeps the empty Trash warning enabled
- hides recent tags
- opens new Finder windows to `~/Development`
- opens folders in tabs instead of new windows
- shows external drives and removable media on the Desktop
- keeps connected servers available in the Sidebar but hidden on the Desktop
- hides internal hard disks on the Desktop
- keeps hidden files hidden by default, since `Cmd + Shift + .` can toggle them manually
- avoids writing `.DS_Store` files on USB and network volumes
- stores screenshots in `~/Desktop/.desktop-files/screenshots`

After applying preferences, the script restarts `cfprefsd`, `SystemUIServer`, and `Finder`, then opens Finder.

## What It Does Not Change

The script does not configure Finder Sidebar favorites, tags, Finder window geometry, per-folder view state, Dock settings, Mission Control, warning behavior for removing items from iCloud Drive, automatic Bin cleanup, or other desktop behavior outside the listed defaults.

It also does not restore the old broken backup plist at `~/Desktop/.desktop-files/finder-fix-backup/com.apple.finder.plist.backup.20260602-172237`. That file only contains `{}`, so restoring it would not recover useful Finder settings.

## Run It

From anywhere:

```bash
bash ~/dotfiles/macos/finder/setup-finder.sh
```

Or from this repository:

```bash
bash macos/finder/setup-finder.sh
```

## Backups

Every run creates a timestamped backup directory before changing preferences:

```text
~/Desktop/.desktop-files/finder-settings/backup-YYYYMMDD-HHMMSS
```

If the script is run more than once in the same second, it adds a numeric suffix instead of overwriting an existing backup directory.

The script backs up these preference files when present:

- `~/Library/Preferences/com.apple.finder.plist`
- `~/Library/Preferences/.GlobalPreferences.plist`
- `~/Library/Preferences/com.apple.sidebarlists.plist`
- `~/Library/Preferences/com.apple.desktopservices.plist`
- `~/Library/Preferences/com.apple.screencapture.plist`

## Manual Finder Sidebar Setup

Finder Sidebar state is manual and should not be automated through plist mutation. Apple stores some sidebar settings in ways that are brittle across macOS versions.

Open Finder, then go to `Finder > Settings > Sidebar` and enable the items you want. Recommended items:

- AirDrop
- Applications
- Desktop
- Documents
- Downloads
- Home folder
- iCloud Drive
- External disks
- Connected servers
- Google Drive

## Manual List View Setup

Some List View details are per-folder Finder view state, so set the defaults manually after running the script:

1. Open a Finder window.
2. Choose `View > as List`.
3. Choose `View > Group By > None`.
4. Choose `View > Sort By > Name`.
5. Choose `View > Show View Options`.
6. Enable `Always open in list view`.
7. Set `Text Size` to `14`.
8. Enable columns for `Date Modified`, `Date Created`, `Size`, and `Kind`.
9. Leave `Calculate all sizes` disabled.
10. Keep `Show icon preview` enabled.
11. Click `Use as Defaults`.
