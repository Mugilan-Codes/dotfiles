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

# Dump the current Homebrew state into the dotfiles Brewfile.
# Also shows the Brewfile diff if the dotfiles repo exists.
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

# Clean user cache safely.
# Usage:
#   cleanmac
cleanmac() {
  echo "Cleaning user cache..."
  rm -rf ~/Library/Caches/*
  echo "Done."
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

# Flutter / Dart cleanup without touching project source files.
# Usage:
#   cleanfluttercache
cleanfluttercache() {
  command -v flutter >/dev/null 2>&1 || { echo "flutter not found"; return 1; }

  echo "Cleaning Flutter and simulator caches..."
  flutter clean 2>/dev/null || true
  rm -rf ~/Library/Developer/CoreSimulator/Caches/*
  rm -rf ~/.dartServer/
  echo "Done."
}

# Remove Xcode DerivedData.
# Usage:
#   cleanderived
cleanderived() {
  rm -rf ~/Library/Developer/Xcode/DerivedData/*
  echo "Removed Xcode DerivedData."
}