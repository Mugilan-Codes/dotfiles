# ~/.oh-my-zsh/custom/functions.zsh
# Put anything here that needs logic, arguments, checks, or multiple commands.
# Aliases are for shortcuts. Functions are for workflows.

# ─────────────────────────────
# ⚙️ Utility Functions
# ─────────────────────────────

# Kill all processes listening on a given TCP port.
# Usage:
#   killport 3000
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi

  local pids
  pids=$(lsof -ti tcp:"$1")

  if [[ -z "$pids" ]]; then
    echo "No processes found on port $1"
    return 0
  fi

  echo "Killing processes on port $1: $pids"
  echo "$pids" | xargs kill
}

# Force-kill all processes listening on a given TCP port.
# Use only if normal killport does not work.
# Usage:
#   killportf 3000
killportf() {
  if [[ -z "$1" ]]; then
    echo "Usage: killportf <port>"
    return 1
  fi

  local pids
  pids=$(lsof -ti tcp:"$1")

  if [[ -z "$pids" ]]; then
    echo "No processes found on port $1"
    return 0
  fi

  echo "Force-killing processes on port $1: $pids"
  echo "$pids" | xargs kill -9
}

# Create a directory and immediately cd into it.
# Usage:
#   mkcd my-folder
mkcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkcd <directory>"
    return 1
  fi

  mkdir -p "$1" && cd "$1"
}

# Extract common archive formats.
# Usage:
#   extract file.zip
#   extract archive.tar.gz
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <archive_file>"
    return 1
  fi

  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  case "$file" in
    *.tar.bz2) tar xjf "$file" ;;
    *.tar.gz)  tar xzf "$file" ;;
    *.tar.xz)  tar xJf "$file" ;;
    *.tar)     tar xf "$file" ;;
    *.tbz2)    tar xjf "$file" ;;
    *.tgz)     tar xzf "$file" ;;
    *.zip)     unzip "$file" ;;
    *.rar)     unrar x "$file" ;;
    *.7z)      7z x "$file" ;;
    *)         echo "Don't know how to extract: $file"; return 1 ;;
  esac
}

# Serve the current directory over HTTP.
# Usage:
#   servehere
#   servehere 9090
servehere() {
  local port=${1:-8080}
  echo "Starting HTTP server at http://localhost:$port"
  python3 -m http.server "$port"
}

# Restart macOS Core Audio daemon.
# Useful if audio gets stuck or devices behave oddly.
# Usage:
#   fixaudio
fixaudio() {
  echo "Restarting Core Audio..."
  sudo pkill coreaudiod
}

# Fix npm global permissions for the active npm prefix.
# Useful if global installs fail due to ownership issues.
# Usage:
#   fixperm
fixperm() {
  local prefix
  prefix="$(npm config get prefix)"

  if [[ -z "$prefix" || ! -d "$prefix" ]]; then
    echo "Invalid npm prefix: $prefix"
    return 1
  fi

  echo "Fixing npm global permissions under: $prefix"
  sudo chown -R "$(whoami)" \
    "$prefix/lib/node_modules" \
    "$prefix/bin" \
    "$prefix/share" 2>/dev/null
}

# Find files/directories using the real `fd` binary.
# Includes hidden files and skips .git by default.
# This avoids conflict with your alias: fd="fvm dart"
# Usage:
#   fdf
#   fdf package
#   fdf -t f
#   fdf -t d
fdf() {
  command fd --hidden --exclude .git "$@"
}

# Fuzzy-pick a directory under the current path and cd into it.
# Usage:
#   cdf
cdf() {
  local dir
  dir=$(command fd --type d --hidden --exclude .git . 2>/dev/null | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

# Quick tldr lookup with fuzzy selection.
# Usage:
#   cheat
cheat() {
  local cmd
  cmd=$(tldr --list | fzf)
  [[ -n "$cmd" ]] && tldr "$cmd"
}

# Create and jump into a temporary working directory.
# Usage:
#   tmpd
tmpd() {
  local dir
  dir=$(mktemp -d "${TMPDIR:-/tmp}/work.XXXXXX")
  cd "$dir" || return
  echo "Entered $dir"
}

# Open the current Finder directory in terminal
# Usage:
#   finder
finder() {
  local dir
  dir=$(osascript -e 'tell application "Finder" to POSIX path of (target of front window as alias)')
  cd "$dir" || return
  echo "Moved to: $dir"
}

# Dump current Homebrew state into the dotfiles Brewfile.
# Shows diff only if Brewfile changed.
# Usage:
#   brewdump
brewdump() {
  local repo="$HOME/dotfiles"
  local file="$repo/Brewfile"

  command -v brew >/dev/null 2>&1 || {
    echo "brew not found"
    return 1
  }

  brew bundle dump --file="$file" --force || return 1

  if command -v git >/dev/null 2>&1 && [[ -d "$repo/.git" ]]; then
    if ! git -C "$repo" diff --quiet -- "$file"; then
      echo "Brewfile updated. Changes:"
      git -C "$repo" --no-pager diff -- "$file"
    else
      echo "Brewfile unchanged."
    fi
  else
    echo "Updated: $file"
  fi
}

# Install a Homebrew formula, then refresh Brewfile if install succeeds.
# Usage:
#   brewadd jq
#   brewadd --cask iterm2
brewadd() {
  [[ $# -eq 0 ]] && { echo "Usage: brewadd <brew install args>"; return 1; }
  brew install "$@" && brewdump
}

# Uninstall a Homebrew formula/cask, then refresh Brewfile if uninstall succeeds.
# Usage:
#   brewrm jq
#   brewrm --cask iterm2
brewrm() {
  [[ $# -eq 0 ]] && { echo "Usage: brewrm <brew uninstall args>"; return 1; }
  brew uninstall "$@" && brewdump
}

# Tap a Homebrew repo, then refresh Brewfile.
# Usage:
#   brewtap hashicorp/tap
brewtap() {
  [[ $# -eq 0 ]] && { echo "Usage: brewtap <tap>"; return 1; }
  brew tap "$@" && brewdump
}

# Untap a Homebrew repo, then refresh Brewfile.
# Usage:
#   brewuntap hashicorp/tap
brewuntap() {
  [[ $# -eq 0 ]] && { echo "Usage: brewuntap <tap>"; return 1; }
  brew untap "$@" && brewdump
}

# Dump Brewfile and commit it if changed.
# Usage:
#   brewsave
#   brewsave "Update Brewfile after installing jq"
brewsave() {
  local repo="$HOME/dotfiles"
  local msg="${1:-Update Brewfile}"

  brewdump || return 1

  if [[ -d "$repo/.git" ]] && ! git -C "$repo" diff --quiet -- Brewfile; then
    git -C "$repo" add Brewfile &&
    git -C "$repo" commit -m "$msg"
  else
    echo "No Brewfile changes to commit."
  fi
}

# Commit + push Brewfile if changed
# Usage:
#   brewpush
#   brewpush "Update Brewfile"
brewpush() {
  local msg="${1:-Update Brewfile}"

  brewsave "$msg" || return 1

  if [[ -d "$HOME/dotfiles/.git" ]]; then
    git -C "$HOME/dotfiles" push
  fi
}

# ─────────────────────────────
# 🔧 Git Helpers
# ─────────────────────────────

# Add, commit, and push current HEAD quickly.
# Usage:
#   gcommit "feat: add login validation"
gcommit() {
  if [[ -z "$1" ]]; then
    echo 'Usage: gcommit "your message here"'
    return 1
  fi

  git add . && git commit -m "$1" && git push origin HEAD
}

# Create and switch to a new branch.
# Usage:
#   gcreate feature/my-branch
gcreate() {
  if [[ -z "$1" ]]; then
    echo "Usage: gcreate <branch-name>"
    return 1
  fi

  git checkout -b "$1"
}

# Interactively delete merged local branches.
# Keeps main/master and ignores the currently checked out branch.
# Usage:
#   gclean
git-clean-branches() {
  echo "Fetching remote..."
  git fetch -p

  echo "Merged branches (excluding main/master):"
  git branch --merged \
    | grep -v '^\*' \
    | grep -v '^main$' \
    | grep -v '^master$' \
    | sed 's/^[[:space:]]*//' \
    | fzf -m --preview "git log --oneline {}" \
    | xargs -I {} git branch -d "{}"
}

# ─────────────────────────────
# ⚡ Fuzzy Helpers
# ─────────────────────────────

# Open a file selected via fd + fzf.
# Much faster than scanning blindly with plain fzf.
# Usage:
#   fo
fzf-open() {
  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always {} | head -100'
  else
    preview_cmd='sed -n "1,100p" {}'
  fi

  local file
  file=$(command fd --type f --hidden --exclude .git . 2>/dev/null | fzf --preview="$preview_cmd" --height=40%)

  [[ -n "$file" ]] && ${EDITOR:-code} "$file"
}

# Search file contents using ripgrep, then open a selected file.
# Usage:
#   searchf login
#   fzf-content "FormEntryScreen"
fzf-content() {
  if [[ -z "$1" ]]; then
    echo "Usage: fzf-content <search-term>"
    return 1
  fi

  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always {} | head -100'
  else
    preview_cmd='sed -n "1,100p" {}'
  fi

  local file
  file=$(rg --files-with-matches "$1" . 2>/dev/null | fzf --preview="$preview_cmd")

  [[ -n "$file" ]] && ${EDITOR:-code} "$file"
}

# Interactive live grep using ripgrep + fzf.
# Opens the selected file at the matching line in VS Code when possible.
# Usage:
#   fg
# Type your query inside fzf after it opens.
fglive() {
  local result
  result=$(
    rg --line-number --no-heading --color=always "." . 2>/dev/null \
      | fzf --ansi \
            --delimiter ':' \
            --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
            --bind 'change:reload:rg --line-number --no-heading --color=always {q} . 2>/dev/null || true'
  )

  [[ -z "$result" ]] && return

  local file line
  file=$(echo "$result" | cut -d: -f1)
  line=$(echo "$result" | cut -d: -f2)

  if command -v code >/dev/null 2>&1; then
    code -g "$file:$line"
  else
    ${EDITOR:-code} "$file"
  fi
}

# ─────────────────────────────
# 📔 Daily Worklog Template
# ─────────────────────────────

# Create or open today's markdown work log.
# Usage:
#   journal
#   dailylog
dailylog() {
  local today="$HOME/Projects/logs/$(date +%Y-%m-%d).md"
  mkdir -p "$(dirname "$today")"

  if [[ ! -f "$today" ]]; then
    cat <<EOF > "$today"
# 🗓️ Work Log — $(date '+%A, %B %d, %Y')

## ✅ Done
- 

## 🔧 In Progress
- 

## ⏭️ Next Up
- 

## 🧠 Notes / Learnings
- 

## 🤔 Blockers
- 

EOF
  fi

  ${EDITOR:-code} "$today"
}

# ─────────────────────────────
# 📟 tmux Helpers
# ─────────────────────────────

# Pick an existing tmux session or create a new one.
# Usage:
#   tm
#   tmuxx
tmuxx() {
  local session
  session=$((tmux ls -F "#{session_name}" 2>/dev/null; echo "[new]") | fzf --prompt="tmux session ▶ ")

  [[ -z "$session" ]] && return

  if [[ "$session" == "[new]" ]]; then
    read "session?New session name: "
    [[ -z "$session" ]] && return
    tmux new-session -s "$session"
  else
    tmux attach -t "$session" 2>/dev/null || tmux new-session -s "$session"
  fi
}

# Open a project from zoxide into its own tmux session.
# Reuses an existing session if present.
# Named `sessionize` to avoid conflict with the system `proj` binary.
# Usage:
#   sessionize
sessionize() {
  local dir
  dir=$(zoxide query -l | fzf --prompt="project ▶ ")

  [[ -z "$dir" ]] && return

  local name
  name=$(basename "$dir")

  if tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
  else
    tmux new-session -s "$name" -c "$dir"
  fi
}

# Create a quick 3-pane dev session inside a chosen project.
# Uses the project folder name as the tmux session name.
# Good for editor / terminal / logs workflow.
# Usage:
#   tmuxdev
tmuxdev() {
  local dir
  dir=$(zoxide query -l | fzf --prompt="project ▶ ")
  [[ -z "$dir" ]] && return

  local name
  name=$(basename "$dir")

  if tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
    return
  fi

  tmux new-session -d -s "$name" -c "$dir"
  tmux split-window -h -c "$dir"
  tmux split-window -v -c "$dir"
  tmux select-pane -t 0
  tmux attach -t "$name"
}

# ─────────────────────────────
# 🚀 zoxide + fzf
# ─────────────────────────────

# Jump to a recent directory using zoxide + fzf.
# If zoxide history is empty, fall back to fd directory search.
# Usage:
#   zz
# First use: zoxide needs some history. Just `cd` into a few directories first.
zoxfz() {
  local dir

  if [[ -z "$(zoxide query -l 1 2>/dev/null)" ]]; then
    echo "No zoxide history yet. Falling back to fd directory search..."
    dir=$(command fd --type d --hidden --exclude .git . "$HOME" 2>/dev/null | fzf --prompt="jump ▶ ")
    [[ -n "$dir" ]] && cd "$dir"
    return
  fi

  dir=$(
    zoxide query -l 50 \
      | fzf --prompt="jump ▶ " \
            --preview='
              if [ -d "{}/.git" ]; then
                git -C {} --no-pager log --oneline --decorate --graph -10
              else
                eza -1 --icons --color=always {} | head -40
              fi
            '
  )

  [[ -n "$dir" ]] && cd "$dir"
}

# ─────────────────────────────
# 📋 taskwarrior Helpers
# ─────────────────────────────

# Pick a pending task interactively.
# Usage:
#   task-fzf
task-fzf() {
  local id
  id=$(task status:pending rc.report.next.columns=id,description rc.report.next.labels=on \
    | sed -E 's/^ +//' \
    | fzf --prompt="tasks ▶ " \
    | awk '{print $1}')

  [[ -n "$id" ]] && task "$id"
}

# ─────────────────────────────
# 🧹 Maintenance Helpers
# ─────────────────────────────

# Empty the current user's macOS Trash safely.
#
# Why this exists:
#   The old alias used `rm -rf ~/.Trash/*`, which was fast but too easy to
#   trigger accidentally and did not ask for confirmation. This function shows
#   the Trash size and item count first, then requires explicit confirmation.
#
# When to use:
#   - After checking Trash size with `trashsize`
#   - When you are sure you no longer need the files in Trash
#   - When you want to empty Trash from terminal instead of Finder
#
# Warning:
#   This permanently removes files from ~/.Trash. It does not move them
#   somewhere else. There is no normal undo after this.
#
# Usage:
#   emptytrash
emptytrash() {
  local trash_dir="$HOME/.Trash"

  if [[ ! -d "$trash_dir" ]]; then
    echo "Trash directory not found: $trash_dir"
    return 1
  fi

  local size
  local count
  size=$(du -sh "$trash_dir" 2>/dev/null | awk '{print $1}')
  count=$(find "$trash_dir" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')

  if [[ "$count" == "0" ]]; then
    echo "Trash is already empty."
    return 0
  fi

  echo "WARNING: This will permanently empty your macOS Trash."
  echo "Trash: $trash_dir"
  echo "Size : ${size:-unknown}"
  echo "Items: $count"
  echo

  read "confirm?Type EMPTY to permanently delete these files: "

  if [[ "$confirm" != "EMPTY" ]]; then
    echo "Cancelled."
    return 1
  fi

  find "$trash_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  echo "Trash emptied."
}

# Clean user cache files safely with confirmation.
#
# Why this exists:
#   The old version immediately removed everything under ~/Library/Caches.
#   That is usually safe, but it is still an aggressive cleanup and should not
#   happen accidentally. This function shows the cache size first and requires
#   explicit confirmation.
#
# When to use:
#   - macOS apps feel bloated or cache-heavy
#   - You want to reclaim local disk space
#   - You are not in the middle of active work
#
# Warning:
#   Apps may recreate cache files later and may feel slower briefly after this.
#   Some cache files may be skipped if currently in use.
#
# Usage:
#   cleanmac
cleanmac() {
  local cache_dir="$HOME/Library/Caches"

  if [[ ! -d "$cache_dir" ]]; then
    echo "Cache directory not found: $cache_dir"
    return 1
  fi

  local size
  local count
  size=$(du -sh "$cache_dir" 2>/dev/null | awk '{print $1}')
  count=$(find "$cache_dir" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')

  if [[ "$count" == "0" ]]; then
    echo "User cache directory is already empty."
    return 0
  fi

  echo "WARNING: This will remove user cache files."
  echo "Cache: $cache_dir"
  echo "Size : ${size:-unknown}"
  echo "Items: $count"
  echo
  echo "Avoid running this during active work."
  echo

  read "confirm?Type CLEAN to remove user cache files: "

  if [[ "$confirm" != "CLEAN" ]]; then
    echo "Cancelled."
    return 1
  fi

  find "$cache_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null
  echo "Done. Some cache files may be skipped if they were in use."
}

# Homebrew cleanup.
# Usage:
#   cleanbrew
cleanbrew() {
  command -v brew >/dev/null 2>&1 || { echo "brew not found"; return 1; }
  brew autoremove && brew cleanup -s
}

# npm cache verification / cleanup.
# Usage:
#   cleannpm
cleannpm() {
  command -v npm >/dev/null 2>&1 || { echo "npm not found"; return 1; }
  npm cache verify
}

# Yarn cache cleanup.
# Usage:
#   cleanyarn
cleanyarn() {
  command -v yarn >/dev/null 2>&1 || { echo "yarn not found"; return 1; }
  yarn cache clean
}

# Flutter / Dart cleanup with confirmation.
#
# Use when:
#   - Flutter build behaves weirdly
#   - Simulator cache causes odd issues
#   - Dart analysis/server feels stuck
#
# Warning:
#   This removes simulator caches and Dart server cache. It does not touch
#   project source files, but apps/tools may rebuild caches afterwards.
#
# Note:
#   This expects `flutter` to be available as a command.
#   If you only use FVM and do not have global flutter in PATH,
#   prefer running `f clean` inside the project.
#
# Usage:
#   cleanfluttercache
cleanfluttercache() {
  command -v flutter >/dev/null 2>&1 || { echo "flutter not found"; return 1; }

  echo "WARNING: This will clean Flutter build output and local Flutter/Dart caches."
  echo "It does not delete project source files."
  echo

  read "confirm?Type FLUTTERCLEAN to continue: "

  if [[ "$confirm" != "FLUTTERCLEAN" ]]; then
    echo "Cancelled."
    return 1
  fi

  echo "Cleaning Flutter and simulator caches..."
  flutter clean 2>/dev/null || true
  rm -rf ~/Library/Developer/CoreSimulator/Caches/*
  rm -rf ~/.dartServer/
  echo "Done."
}

# Remove Xcode DerivedData safely with confirmation.
#
# Use when:
#   - Xcode/iOS builds are stuck
#   - Old DerivedData is taking too much space
#   - Flutter iOS build behaves oddly
#
# Warning:
#   This does not delete source code, but Xcode will rebuild indexes/build data.
#
# Usage:
#   cleanderived
cleanderived() {
  local derived_dir="$HOME/Library/Developer/Xcode/DerivedData"

  if [[ ! -d "$derived_dir" ]]; then
    echo "DerivedData directory not found: $derived_dir"
    return 0
  fi

  local size
  size=$(du -sh "$derived_dir" 2>/dev/null | awk '{print $1}')

  echo "WARNING: This will remove Xcode DerivedData."
  echo "Path: $derived_dir"
  echo "Size: ${size:-unknown}"
  echo

  read "confirm?Type DERIVED to continue: "

  if [[ "$confirm" != "DERIVED" ]]; then
    echo "Cancelled."
    return 1
  fi

  find "$derived_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null
  echo "Removed Xcode DerivedData."
}

# ─────────────────────────────
# 🧹 neatCLI Helpers
# ─────────────────────────────

# Generate neatCLI zsh completions.
# Usage:
#   neatcomp
neatcomp() {
  mkdir -p "$HOME/.zfunc"
  neatcli completions zsh > "$HOME/.zfunc/_neatcli"
  compinit
  echo "neatCLI completions installed & reloaded"
}

# Preview organizing any folder by type.
# Usage:
#   neatpreview
#   neatpreview ~/Downloads
neatpreview() {
  local dir="${1:-.}"
  neatcli organize "$dir" --by-type --show-all-files
}

# Execute organizing any folder by type.
# Usage:
#   neatexec ~/Downloads
neatexec() {
  local dir="${1:-.}"
  neatcli organize "$dir" --by-type --execute
}

# Find duplicates in any folder.
# Usage:
#   neatdups
#   neatdups ~/Downloads
neatdups() {
  local dir="${1:-.}"
  neatcli duplicates "$dir"
}

# Trash duplicate files after confirmation.
# Usage:
#   neatdupsx ~/Downloads
neatdupsx() {
  local dir="${1:-.}"
  neatcli duplicates "$dir" --delete --trash --execute
}

# Organize photos by EXIF date taken.
# Usage:
#   neatphotos ~/Pictures
neatphotos() {
  local dir="${1:-.}"
  neatcli organize "$dir" --by-date-taken
}

# Execute photo organization by EXIF date taken.
# Usage:
#   neatphotosx ~/Pictures
neatphotosx() {
  local dir="${1:-.}"
  neatcli organize "$dir" --by-date-taken --execute
}

# Show folder stats.
# Usage:
#   neatstats
#   neatstats ~/Downloads
neatstats() {
  local dir="${1:-.}"
  neatcli stats "$dir"
}

# Safe Downloads cleanup workflow.
# Step 1: stats
# Step 2: preview organization
# Step 3: check duplicates
# Step 4: optionally execute
# Usage:
#   dlclean
dlclean() {
  local dir="$HOME/Downloads"

  echo "📊 Downloads stats:"
  neatcli stats "$dir"

  echo ""
  echo "🧹 Preview organization:"
  neatcli organize "$dir" --by-type --show-all-files

  echo ""
  echo "🔍 Duplicate check:"
  neatcli duplicates "$dir"

  echo ""
  echo "Nothing was changed."
  echo "Run 'dlcleanx' to execute the organization."
}

# Execute Downloads organization safely.
# Usage:
#   dlcleanx
dlcleanx() {
  local dir="$HOME/Downloads"

  echo "This will organize: $dir"
  echo "Files can be restored using: nundo"
  echo ""

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli organize "$dir" --by-type --execute

  echo ""
  echo "Done. If something looks wrong, run:"
  echo "  nundo"
}

# Clean old Downloads files safely by moving to Trash.
# Default: older than 30 days.
# Usage:
#   dlold
#   dlold 60d
dlold() {
  local dir="$HOME/Downloads"
  local age="${1:-30d}"

  neatcli clean "$dir" --older-than "$age" --trash
}

# Execute old Downloads cleanup.
# Usage:
#   dloldx
#   dloldx 60d
dloldx() {
  local dir="$HOME/Downloads"
  local age="${1:-30d}"

  echo "This will move files older than $age from Downloads to Trash."
  echo ""

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli clean "$dir" --older-than "$age" --trash --execute
}

# ─────────────────────────────
# 🐳 OrbStack / Docker Functions
# ─────────────────────────────

# Show complete OrbStack + Docker health.
# Usage:
#   docker-health
docker-health() {
  echo "== OrbStack =="
  orb status 2>/dev/null || echo "OrbStack is not running or orb CLI is unavailable"

  echo
  echo "== OrbStack Config =="
  orb config show | grep -E "cpu|memory_mib|rosetta|k8s.enable|docker.expose_ports_to_lan|machines.expose_ports_to_lan|mount_hide_shared|docker.set_context" 2>/dev/null

  echo
  echo "== Docker Contexts =="
  docker context ls

  echo
  echo "== Docker CLI =="
  which -a docker

  echo
  echo "== Docker Version =="
  docker version

  echo
  echo "== Compose Version =="
  docker compose version

  echo
  echo "== Running Containers =="
  docker ps
}

# Force Docker CLI to use OrbStack.
# Usage:
#   docker-use-orb
docker-use-orb() {
  docker context use orbstack
  docker context ls
}

# Full OrbStack restart.
# Useful after config changes.
# Usage:
#   orbreload
orbreload() {
  orb stop && orb start
  docker context use orbstack >/dev/null 2>&1
  orb status
}

# Restart only OrbStack Docker engine.
# Usage:
#   docker-restart
docker-restart() {
  orb restart docker
  docker version
}

# Open shell inside a running container.
# Tries bash first, then sh.
# Usage:
#   dsh container_name
#   dsh container_name bash
#   dsh container_name sh
dsh() {
  if [[ -z "$1" ]]; then
    echo "Usage: dsh <container-name-or-id> [bash|sh]"
    return 1
  fi

  local container="$1"
  local shell="${2:-}"

  if [[ -n "$shell" ]]; then
    docker exec -it "$container" "$shell"
    return
  fi

  docker exec -it "$container" bash 2>/dev/null || docker exec -it "$container" sh
}

# Follow logs for a container.
# Usage:
#   dlogs container_name
dlogs() {
  if [[ -z "$1" ]]; then
    echo "Usage: dlogs <container-name-or-id>"
    return 1
  fi

  docker logs -f "$1"
}

# Show container IP address.
# Usage:
#   dip container_name
dip() {
  if [[ -z "$1" ]]; then
    echo "Usage: dip <container-name-or-id>"
    return 1
  fi

  docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Show mapped ports for a container.
# Usage:
#   dports container_name
dports() {
  if [[ -z "$1" ]]; then
    echo "Usage: dports <container-name-or-id>"
    return 1
  fi

  docker port "$1"
}

# Inspect a container/image/volume/network.
# Usage:
#   dinspect container_name
dinspect() {
  if [[ -z "$1" ]]; then
    echo "Usage: dinspect <docker-object-name-or-id>"
    return 1
  fi

  docker inspect "$1"
}

# Remove stopped containers only.
# Usage:
#   docker-clean-containers
docker-clean-containers() {
  echo "This removes stopped containers only."
  docker container prune
}

# Safe Docker cleanup.
# Removes stopped containers, unused networks, dangling images, and build cache.
# Does NOT remove volumes.
# Usage:
#   docker-clean-safe
docker-clean-safe() {
  echo "This removes:"
  echo "- stopped containers"
  echo "- unused networks"
  echo "- dangling images"
  echo "- build cache"
  echo
  echo "It does NOT remove Docker volumes."
  echo

  docker system prune
}

# Hard Docker cleanup.
# WARNING: removes unused images and volumes.
# Can delete local DB data.
# Usage:
#   docker-clean-hard
docker-clean-hard() {
  echo "WARNING:"
  echo "This removes:"
  echo "- stopped containers"
  echo "- unused networks"
  echo "- unused images"
  echo "- build cache"
  echo "- unused volumes"
  echo
  echo "This can delete local Postgres/MySQL/Redis data stored in Docker volumes."
  echo

  read "confirm?Type DELETE to continue: "

  if [[ "$confirm" == "DELETE" ]]; then
    docker system prune -a --volumes
  else
    echo "Cancelled."
  fi
}

# Show Docker disk usage.
# Usage:
#   docker-disk
docker-disk() {
  docker system df -v
}

# Quick temporary PostgreSQL container for testing.
#
# Use when:
#   - You need a fast local Postgres DB for Spring Boot/Node testing
#   - You do not want to write a full compose.yaml yet
#
# Default connection:
#   Host: localhost
#   Port: 5432
#   DB: testdb
#   User: mugilan
#   Password: password
#
# Notes:
#   - Container name is fixed: pgquick
#   - If it already exists, run pgquickrm first
#   - Use a different port if 5432 is busy: pgquick 5433
#
# Usage:
#   pgquick
#   pgquick 5433
pgquick() {
  local port="${1:-5432}"

  docker run --name pgquick \
    -e POSTGRES_DB=testdb \
    -e POSTGRES_USER=mugilan \
    -e POSTGRES_PASSWORD=password \
    -p "$port:5432" \
    -d postgres:16

  echo "Postgres running:"
  echo "Host: localhost"
  echo "Port: $port"
  echo "DB: testdb"
  echo "User: mugilan"
  echo "Password: password"
}

# Stop and remove the temporary pgquick PostgreSQL container.
#
# Use when:
#   - You are done testing
#   - You want to recreate pgquick cleanly
#
# Usage:
#   pgquickrm
pgquickrm() {
  docker rm -f pgquick
}

# Quick temporary Redis container for testing.
#
# Use when:
#   - You need Redis for Spring Boot/Node testing
#   - You want to test cache/session/queue behavior quickly
#
# Notes:
#   - Container name is fixed: redisquick
#   - If it already exists, run redisquickrm first
#   - Use a different port if 6379 is busy: redisquick 6380
#
# Usage:
#   redisquick
#   redisquick 6380
redisquick() {
  local port="${1:-6379}"

  docker run --name redisquick \
    -p "$port:6379" \
    -d redis:7

  echo "Redis running on localhost:$port"
}

# Stop and remove the temporary redisquick Redis container.
#
# Usage:
#   redisquickrm
redisquickrm() {
  docker rm -f redisquick
}

# ─────────────────────────────
# 🧭 Alias / Function Namespace Helpers
# ─────────────────────────────

# Check whether a name is already used by zsh.
#
# Why this exists:
#   Before creating a new alias or function, you can check whether the name is
#   already taken by an alias, function, builtin command, external command, or
#   zsh reserved word.
#
# When to use:
#   - Before adding a new alias
#   - Before adding a new function
#   - When a command behaves unexpectedly
#   - When you want to know whether a short name like "dcu", "gs", "k", etc. is safe
#
# Usage:
#   namecheck dcu
#   namecheck docker
#   namecheck dcu docker-health pgquick
#
# Example:
#   namecheck dcu
#
# Output meaning:
#   ✅ Free      -> safe to use as a new alias/function name
#   ⚠️ Not free -> name already exists somewhere
namecheck() {
  emulate -L zsh

  if [[ $# -eq 0 ]]; then
    echo "Usage: namecheck <name> [name2 name3 ...]"
    return 1
  fi

  local name
  local found

  for name in "$@"; do
    echo
    echo "== $name =="

    found=0

    if (( ${+aliases[$name]} )); then
      echo "Alias: ${aliases[$name]}"
      found=1
    fi

    if (( ${+functions[$name]} )); then
      echo "Function: defined"
      found=1
    fi

    if (( ${+builtins[$name]} )); then
      echo "Builtin: zsh builtin"
      found=1
    fi

    if (( ${+commands[$name]} )); then
      echo "Command: ${commands[$name]}"
      found=1
    fi

    if (( ${+reswords[$name]} )); then
      echo "Reserved word: zsh reserved word"
      found=1
    fi

    if (( found == 0 )); then
      echo "✅ Free: you can use this name"
    else
      echo "⚠️ Not free: this name already exists"
      echo
      whence -va "$name" 2>/dev/null
    fi
  done
}


# Count how many times a command/alias/function appears in your zsh history.
#
# Why this exists:
#   zsh does not automatically tell you whether you actually use your aliases
#   and functions. This searches your shell history and gives a rough usage count.
#
# When to use:
#   - When cleaning your dotfiles
#   - Before deleting old aliases/functions
#   - To find whether a shortcut is actually useful
#   - To compare whether you use the alias or the full command more often
#
# Usage:
#   usedcount dcu
#   usedcount docker-health
#   usedcount pgquick
#
# Example:
#   usedcount dcu
#
# Output:
#   dcu used 12 time(s) in shell history
#
# Note:
#   This is history-based, so it is not perfect. If old history was deleted,
#   the count will only reflect the history currently available.
usedcount() {
  emulate -L zsh

  if [[ -z "$1" ]]; then
    echo "Usage: usedcount <command-or-alias-name>"
    return 1
  fi

  local name="$1"
  local count

  # Token-based match instead of regex-based grep.
  # This works better for aliases like `..` and `...`, where dots would
  # otherwise behave like regex wildcards.
  count=$(
    fc -l 1 2>/dev/null \
      | awk -v target="$name" '
          {
            $1=""
            sub(/^ /, "")
            n = split($0, parts, /[[:space:];|&]+/)
            for (i = 1; i <= n; i++) {
              if (parts[i] == target) c++
            }
          }
          END { print c + 0 }
        '
  )

  echo "$name used $count time(s) in shell history"
}