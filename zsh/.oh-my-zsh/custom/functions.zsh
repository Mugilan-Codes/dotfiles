# # ─────────────────────────────
# # ⚙️  Utility Functions
# # ─────────────────────────────

# # Kill all processes on a port
# killport() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: killport <port>"
#     return 1
#   fi

#   local pids
#   pids=$(lsof -ti:"$1")

#   if [[ -z "$pids" ]]; then
#     echo "No processes found on port $1"
#     return 0
#   fi

#   echo "Killing processes on port $1: $pids"
#   echo "$pids" | xargs kill -9
#   echo "Done."
# }

# # Quick mkdir + cd
# mkcd() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: mkcd <directory>"
#     return 1
#   fi
#   mkdir -p "$1" && cd "$1"
# }

# # Extract archives (zip, tar, etc.)
# extract() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: extract <archive_file>"
#     return 1
#   fi

#   local file="$1"
#   if [[ ! -f "$file" ]]; then
#     echo "File not found: $file"
#     return 1
#   fi

#   case "$file" in
#     *.tar.bz2)  tar xjf "$file"   ;;
#     *.tar.gz)   tar xzf "$file"   ;;
#     *.tar.xz)   tar xJf "$file"   ;;
#     *.tar)      tar xf "$file"    ;;
#     *.tbz2)     tar xjf "$file"   ;;
#     *.tgz)      tar xzf "$file"   ;;
#     *.zip)      unzip "$file"     ;;
#     *.rar)      unrar x "$file"   ;;
#     *.7z)       7z x "$file"      ;;
#     *)          echo "Don't know how to extract: $file" ; return 1 ;;
#   esac
# }

# # Serve current folder on port (default: 8080)
# servehere() {
#   local port=${1:-8080}
#   echo "Starting HTTP server at http://localhost:$port"
#   python3 -m http.server "$port"
# }

# # ─────────────────────────────
# # 🔧 Git Helpers
# # ─────────────────────────────

# # Git quick commit and push
# gcommit() {
#   if [[ -z "$1" ]]; then
#     echo 'Usage: gcommit "your message here"'
#     return 1
#   fi
#   git add . && git commit -m "$1" && git push origin HEAD
# }

# # Git: create and switch to new branch
# gcreate() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: gcreate <branch-name>"
#     return 1
#   fi
#   git checkout -b "$1"
# }

# # Interactive Git Branch Cleanup
# git-clean-branches() {
#   echo "Fetching remote..."
#   git fetch -p

#   echo "Merged branches (excluding main/master):"
#   git branch --merged \
#     | grep -v '\*' \
#     | grep -v 'main' \
#     | grep -v 'master' \
#     | fzf -m --preview "git log --oneline {}" \
#     | xargs -I {} git branch -d "{}"
# }

# # ─────────────────────────────
# # ⚡ FO: Fuzzy Open Files
# # ─────────────────────────────

# fzf-open() {
#   local file
#   file=$(fzf --preview='bat --style=numbers --color=always {} | head -100' --height=40%)
#   [[ -n "$file" ]] && ${EDITOR:-code} "$file"
# }

# # 🔍 Fuzzy Search File Contents
# fzf-content() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: fzf-content <search-term>"
#     return 1
#   fi

#   local file
#   file=$(rg --files-with-matches "$1" . 2>/dev/null \
#     | fzf --preview="bat --style=numbers --color=always {} | head -100")

#   [[ -n "$file" ]] && ${EDITOR:-code} "$file"
# }

# # ─────────────────────────────
# # 📔 Daily Worklog Template
# # ─────────────────────────────

# dailylog() {
#   local today="$HOME/Projects/logs/$(date +%Y-%m-%d).md"
#   mkdir -p "$(dirname "$today")"

#   if [[ ! -f "$today" ]]; then
#     cat <<EOF > "$today"
# # 🗓️ Work Log — $(date '+%A, %B %d, %Y')

# ## ✅ Done
# - 

# ## 🔧 In Progress
# - 

# ## ⏭️ Next Up
# - 

# ## 🧠 Notes / Learnings
# - 

# ## 🤔 Blockers
# - 

# EOF
#   fi

#   ${EDITOR:-code} "$today"
# }

# # ─────────────────────────────
# # 📟 tmux Session Picker
# # ─────────────────────────────

# tmuxx() {
#   local session
#   session=$((tmux ls -F "#{session_name}" 2>/dev/null; echo "[new]") \
#     | fzf --prompt="tmux session ▶ ")

#   [[ -z $session ]] && return

#   if [[ $session == "[new]" ]]; then
#     read "session?New session name: "
#     [[ -z $session ]] && return
#     tmux new-session -s "$session"
#   else
#     tmux attach -t "$session" 2>/dev/null || tmux new-session -s "$session"
#   fi
# }

# # ─────────────────────────────
# # 🚀 zoxide + fzf jump
# # ─────────────────────────────

# zoxfz() {
#   local dir
#   dir=$(zoxide query -l 50 \
#     | fzf --prompt="jump ▶ " \
#       --preview='if [ -d "{}/.git" ]; then git -C {} --no-pager log --oneline --decorate --graph -10; else exa -1 --icons --color=always {} | head -40; fi'
#   )
#   [[ -n $dir ]] && cd "$dir"
# }

# # ─────────────────────────────
# # 📋 task-fzf: Interactive taskwarrior selector
# # ─────────────────────────────

# task-fzf() {
#   local id
#   id=$(task status:pending rc.report.next.columns=id,description rc.report.next.labels=on \
#        | sed -E 's/^ +//' \
#        | fzf --prompt="tasks ▶ " | awk '{print $1}')

#   [[ -n $id ]] && task "$id"
# }

# # ─────────────────────────────
# # 🧹 macOS Cleanup Helpers
# # ─────────────────────────────

# cleanmac() {
#   echo "🧹 Cleaning macOS user cache (super safe)..."
#   rm -rf ~/Library/Caches/*
#   echo "✨ Done — your Mac is clean and nothing is broken."
# }

# cleanmac-deep() {
#   echo "============================================"
#   echo "   🧹 Running Deep Clean (Safe for Devs)     "
#   echo "============================================"
#   echo
#   echo "This will remove caches, temp files, logs and run brew/npm/yarn cleanups."
#   read "reply?Proceed with deep clean? [y/N] "
#   [[ ! "$reply" =~ ^[yY]$ ]] && echo "Aborted." && return 1

#   echo "➡️  Cleaning user caches..."
#   rm -rf ~/Library/Caches/*

#   echo "➡️  Cleaning app temporary files..."
#   rm -rf ~/Library/Application\ Support/*/Cache*
#   rm -rf ~/Library/Application\ Support/*/Caches

#   echo "➡️  Cleaning system temporary files (safe)..."
#   sudo rm -rf /private/var/tmp/*

#   echo "➡️  Cleaning log files (safe)..."
#   sudo rm -rf /private/var/log/*

#   echo "➡️  Cleaning old crash reports..."
#   rm -rf ~/Library/Logs/DiagnosticReports/*
#   sudo rm -rf /Library/Logs/DiagnosticReports/*

#   echo "➡️  Cleaning browser junk (Safari & Chrome)..."
#   rm -rf ~/Library/Safari/Cache.db
#   rm -rf ~/Library/Application\ Support/Google/Chrome/Default/Cache/*

#   echo "➡️  Cleaning Homebrew cache (safe)..."
#   command -v brew >/dev/null 2>&1 && brew cleanup -s >/dev/null 2>&1

#   echo "➡️  Cleaning npm cache..."
#   command -v npm >/dev/null 2>&1 && npm cache clean --force >/dev/null 2>&1

#   echo "➡️  Cleaning Yarn cache..."
#   command -v yarn >/dev/null 2>&1 && yarn cache clean >/dev/null 2>&1

#   echo "➡️  Cleaning pip cache..."
#   rm -rf ~/Library/Caches/pip

#   echo "➡️  Cleaning Flutter artifact junk (NOT packages!)..."
#   rm -rf ~/Library/Developer/CoreSimulator/Caches/*
#   rm -rf ~/.dartServer/

#   echo "============================================"
#   echo "   ✨ Deep Clean Complete — Your Mac is Fast"
#   echo "============================================"
# }

# ====== REMOVE ABOVE LINES ======

# ~/.oh-my-zsh/custom/functions.zsh

# ─────────────────────────────
# ⚙️ Utility Functions
# ─────────────────────────────

# Kill all processes on a port.
# Usage: killport 3000
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

# Quick mkdir + cd.
# Usage: mkcd my-folder
mkcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkcd <directory>"
    return 1
  fi

  mkdir -p "$1" && cd "$1"
}

# Extract common archive formats.
# Usage: extract archive.zip
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
# Usage: servehere 8080
servehere() {
  local port=${1:-8080}
  echo "Starting HTTP server at http://localhost:$port"
  python3 -m http.server "$port"
}

# Restart macOS Core Audio daemon.
fixaudio() {
  echo "Restarting Core Audio..."
  sudo pkill coreaudiod
}

# Fix npm global permissions for the active npm prefix.
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

# ─────────────────────────────
# 🔧 Git Helpers
# ─────────────────────────────

# Quick add, commit, and push current HEAD.
# Usage: gcommit "feat: add login validation"
gcommit() {
  if [[ -z "$1" ]]; then
    echo 'Usage: gcommit "your message here"'
    return 1
  fi

  git add . && git commit -m "$1" && git push origin HEAD
}

# Create and switch to a new branch.
# Usage: gcreate feature/my-branch
gcreate() {
  if [[ -z "$1" ]]; then
    echo "Usage: gcreate <branch-name>"
    return 1
  fi

  git checkout -b "$1"
}

# Interactively delete merged branches.
# Excludes main/master and current branch marker.
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

# Open a file selected via fzf.
fzf-open() {
  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always {} | head -100'
  else
    preview_cmd='sed -n "1,100p" {}'
  fi

  local file
  file=$(fzf --preview="$preview_cmd" --height=40%)

  [[ -n "$file" ]] && ${EDITOR:-code} "$file"
}

# Search file contents with ripgrep, then open a selected match.
# Usage: fzf-content login
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

# ─────────────────────────────
# 📔 Daily Worklog Template
# ─────────────────────────────

# Create or open today's markdown work log.
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
# 📟 tmux Session Picker
# ─────────────────────────────

# Pick an existing tmux session or create a new one.
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

# ─────────────────────────────
# 🚀 zoxide + fzf jump
# ─────────────────────────────

# Jump to a recent directory using zoxide + fzf.
zoxfz() {
  local dir

  # fallback if no history yet
  if [[ -z "$(zoxide query -l 1 2>/dev/null)" ]]; then
    echo "⚠️ No zoxide history yet. Showing current directories..."
    dir=$(fd -t d . ~ 2>/dev/null | fzf --prompt="jump ▶ ")
    [[ -n "$dir" ]] && cd "$dir"
    return
  fi

  dir=$(zoxide query -l 50 \
    | fzf --prompt="jump ▶ " \
      --preview='if [ -d "{}/.git" ]; then git -C {} --no-pager log --oneline --decorate --graph -10; else eza -1 --icons --color=always {} | head -40; fi')

  [[ -n "$dir" ]] && cd "$dir"
}

# ─────────────────────────────
# 📋 taskwarrior Helpers
# ─────────────────────────────

# Pick a pending task interactively.
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

# Safe user cache cleanup.
cleanmac() {
  echo "Cleaning user cache..."
  rm -rf ~/Library/Caches/*
  echo "Done."
}

# Homebrew cleanup.
cleanbrew() {
  command -v brew >/dev/null 2>&1 || { echo "brew not found"; return 1; }
  brew autoremove && brew cleanup -s
}

# npm cache cleanup.
cleannpm() {
  command -v npm >/dev/null 2>&1 || { echo "npm not found"; return 1; }
  npm cache verify
}

# Yarn cache cleanup.
cleanyarn() {
  command -v yarn >/dev/null 2>&1 || { echo "yarn not found"; return 1; }
  yarn cache clean
}

# Flutter / Dart cache cleanup without deleting your projects.
cleanfluttercache() {
  command -v flutter >/dev/null 2>&1 || { echo "flutter not found"; return 1; }

  echo "Cleaning Flutter and simulator caches..."
  flutter clean 2>/dev/null || true
  rm -rf ~/Library/Developer/CoreSimulator/Caches/*
  rm -rf ~/.dartServer/
  echo "Done."
}

# Xcode DerivedData cleanup.
cleanderived() {
  rm -rf ~/Library/Developer/Xcode/DerivedData/*
  echo "Removed Xcode DerivedData."
}