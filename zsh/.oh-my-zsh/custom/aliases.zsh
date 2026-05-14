# ~/.oh-my-zsh/custom/aliases.zsh
# Personal aliases only.
# Use aliases for short command shortcuts.
# If a command needs logic, arguments, checks, or branching, put it in functions.zsh.

# ─────────────────────────────
# 🛠 Shell & Config
# ─────────────────────────────

# Reload current shell config quickly.
alias reload="omz reload"

# Restart zsh cleanly.
# rz  = restart normal shell
# rzl = restart login shell (use after editing .zprofile or .zlogin)
alias rz="exec zsh"
alias rzl="exec zsh -l"

# Open config files quickly in VS Code.
alias zshconfig="code ~/.zshrc"
alias zprofile="code ~/.zprofile"
alias zshenv="code ~/.zshenv"
alias zlogin="code ~/.zlogin"
alias aliases="code ~/.oh-my-zsh/custom/aliases.zsh"
# Open functions file. Avoid aliasing `functions` because zsh already has a builtin with that name.
alias zfunctions="code ~/.oh-my-zsh/custom/functions.zsh"
alias completions="code ~/.oh-my-zsh/custom/completions.zsh"

# Print PATH entries line-by-line for debugging command resolution.
# Use when `which -a <command>` shows unexpected binaries.
alias path='echo $PATH | tr ":" "\n"'

# Homebrew + Brewfile helpers.
# Functions are defined in functions.zsh.
# bdump = refresh Brewfile only
# bsave = refresh Brewfile and commit if changed
# bpush = refresh, commit, and push Brewfile
alias bdump="brewdump"
alias bsave="brewsave"
alias bpush="brewpush"

# ─────────────────────────────
# 📂 File Listing (eza)
# ─────────────────────────────

# Better ls replacements using eza
alias l='eza -lh --icons'
alias la='eza -lah --icons'
alias ll='eza -lh --icons --git'

# ─────────────────────────────
# 🧭 Navigation
# ─────────────────────────────

# Move up directories quickly.
alias ..="cd .."
alias ...="cd ../.."

# Clear terminal.
alias c="clear"

# Move terminal into the frontmost Finder window's directory.
# Useful when you visually opened a folder in Finder and want terminal there.
# Function is defined in functions.zsh.
alias fdhere="finder"

# ─────────────────────────────
# 🚀 Flutter / Dart (via FVM)
# ─────────────────────────────

# Use FVM-managed Flutter and Dart by default.
alias f="fvm flutter"

# NOTE:
# This intentionally makes `fd` mean "fvm dart".
# Since this conflicts with the popular `fd` file-search binary,
# use the `fdf` function when you want the real fd command.
alias fd="fvm dart"

# Direct local project Flutter binary.
# Use only inside a repo that contains .fvm/flutter_sdk.
alias fv=".fvm/flutter_sdk/bin/flutter"

# Clean Flutter build files and fetch packages again.
# Use when builds behave oddly, dependencies changed, or generated files are stale.
alias frefresh="f clean && f pub get"

# Run build_runner once and delete conflicting generated outputs.
# Use after changing models, MobX stores, json_serializable classes, etc.
alias fbuildrunner="f pub run build_runner build --delete-conflicting-outputs"

# Watch build_runner continuously.
# Use during active development when generated files need to update repeatedly.
alias fwatchrunner="f pub run build_runner watch --delete-conflicting-outputs"

alias fdoctor="f doctor"
alias flog="f logs"

# ─────────────────────────────
# ⚛ React Native
# ─────────────────────────────

# Connect Android device over Wi-Fi debugging.
# Update the IP if your device IP changes.
# Use after connecting device by USB at least once and enabling adb tcpip.
alias rnwifi='adb kill-server && adb tcpip 5555 && adb connect 192.168.0.105:5555 && adb devices'

# Aggressively reset a React Native project.
# WARNING:
# - Deletes node_modules
# - Reinstalls dependencies
# - Resets Metro cache
# Use only when normal reinstall/cache reset does not fix the issue.
alias rnreset='watchman watch-del-all && rm -rf node_modules && npm install && npm start -- --reset-cache'

# ─────────────────────────────
# 🧰 Node / PNPM / Dev
# ─────────────────────────────

# pnpm shortcuts.
alias pn="pnpm"
alias pni="pn install"
alias pnr="pn run"
alias pna="pn add"
alias pnad="pn add -D"
alias pnx="pn dlx"

# Common scripts.
alias dev="pn dev"
alias lint="pn lint"
# Avoid aliasing `test` because it is a shell builtin.
alias ptest="pn test"

# ─────────────────────────────
# 🔧 Git
# ─────────────────────────────

# Personal git shortcuts.
# Oh My Zsh already provides many git aliases, so keep this small.
alias ga="git add ."
alias gnew="git checkout -b"

# Interactive merged-branch cleanup helper.
# Function is defined in functions.zsh.
alias gclean="git-clean-branches"

# ─────────────────────────────
# 🌐 Network / Local Server
# ─────────────────────────────

# Show listening TCP ports.
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"

# Show all network connections.
alias netcons="lsof -i -P -n"

# Quick local IP lookup (Wi-Fi / common interface path on macOS).
alias localip='ipconfig getifaddr en0 || ipconfig getifaddr en1'

# Public IP lookup.
alias publicip='curl -fsSL ifconfig.me && echo'

# Show current DNS servers.
alias dnslist='scutil --dns | grep "nameserver\[[0-9]*\]"'

# Flush DNS cache on macOS.
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Ping Google DNS quickly for connectivity test.
alias pingg='ping 8.8.8.8'

# Basic route table view.
alias routes='netstat -rn'

# Serve current directory on localhost:8080
alias serve="python3 -m http.server 8080"

# ─────────────────────────────
# 💽 System / Maintenance
# ─────────────────────────────

# Update all Homebrew formulae/casks and clean old versions.
# Use occasionally, not blindly before important work.
# This can upgrade tools and sometimes introduce version changes.
alias update="brew update && brew upgrade && brew autoremove && brew cleanup -s"

# Quick CPU / RAM inspection.
alias topmem="ps aux | sort -nr -k 4 | head -15"
alias topcpu="ps aux | sort -nr -k 3 | head -15"
alias ram="top -o mem"
alias cpu="top -o cpu"

# Disk usage helpers.
# du1 = show size of immediate files/folders in current directory.
alias du1="du -d 1 -h . | sort -h"

# Check macOS Trash size.
# If this shows "Operation not permitted", give Full Disk Access to your terminal app:
# System Settings → Privacy & Security → Full Disk Access
alias trashsize='du -sh ~/.Trash 2>/dev/null || echo "Permission denied. Give Full Disk Access to your terminal app, then restart the terminal."'

# Better system monitor.
alias bt="btop"

# ─────────────────────────────
# 🧹 neatCLI Core
# ─────────────────────────────

alias n="neatcli"
alias ntui="neatcli tui"
alias nhist="neatcli history"
alias nundo="neatcli undo"

# Downloads cleanup previews
alias ndl="neatcli organize ~/Downloads --by-type --show-all-files"
alias ndls="neatcli stats ~/Downloads"
alias ndups="neatcli duplicates ~/Downloads"
alias nsim="neatcli similar ~/Downloads"

# Execute versions.
# ndlx reorganizes Downloads immediately.
# ncleanold previews old-file cleanup.
# ncleanoldx moves old files to Trash immediately.
# Safer confirmed workflows are available below as: dlgo and dloldgo.
alias ndlx="neatcli organize ~/Downloads --by-type --execute"
alias ncleanold="neatcli clean ~/Downloads --older-than 30d"
alias ncleanoldx="neatcli clean ~/Downloads --older-than 30d --trash --execute"

# ─────────────────────────────
# 🧹 neatCLI Downloads Workflow
# ─────────────────────────────

alias dlsafe="dlclean"      # Preview cleanup (safe, no changes)
alias dlgo="dlcleanx"       # Execute cleanup (asks confirmation)
alias dloldsafe="dlold"     # Preview old files cleanup
alias dloldgo="dloldx"      # Delete old files (moves to Trash)

# ─────────────────────────────
# 🗃 Projects
# ─────────────────────────────

# Fast jumps to your common project folders.
alias cdp="cd ~/Projects"
alias cdw="cd ~/dev/work/vzlabs"
alias cdapp="cd ~/Projects/Work/appverse-mobileapp"

# ─────────────────────────────
# 📹 Media
# ─────────────────────────────

# Download best available MP4 video + M4A audio where possible.
alias ytdownload='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/bv*+ba/b"'

# ─────────────────────────────
# 🧠 Productivity / Search
# ─────────────────────────────

# Fuzzy file open.
alias fo="fzf-open"

# Fuzzy content search.
alias searchf="fzf-content"

# Open or create today's work log.
alias journal="dailylog"

# Interactive live grep using ripgrep + fzf.
# Keeps `fg` free for zsh job control.
# Function is defined in functions.zsh.
alias fgl="fglive"

# ─────────────────────────────
# 📋 Taskwarrior
# ─────────────────────────────

alias t="task"
alias ta="task add"
alias tl="task list"
alias td="task done"

# ─────────────────────────────
# 📟 tmux
# ─────────────────────────────

# Interactive tmux session picker.
alias tm="tmuxx"

# ─────────────────────────────
# 🚀 zoxide + fzf
# ─────────────────────────────

# Jump to a recent directory interactively.
alias zz="zoxfz"

# ─────────────────────────────
# 🐳 OrbStack / Docker
# ─────────────────────────────

# OrbStack control.
# ostatus  = check if OrbStack is running
# ostart   = start OrbStack
# ostop    = stop OrbStack fully
# orestart = restart only Docker engine inside OrbStack
# over     = show OrbStack version
# oconfig  = show current OrbStack config
alias ostatus="orb status"
alias ostart="orb start"
alias ostop="orb stop"
alias orestart="orb restart docker"
alias over="orb version"
alias oconfig="orb config show"

# Docker context helpers.
# Use dctx to confirm Docker is using OrbStack.
# You want to see: orbstack *
alias dctx="docker context ls"
alias duseorb="docker context use orbstack"

# Docker core shortcuts.
alias dk="docker"
alias dc="docker compose"

# Docker inspect/list helpers.
# dps  = running containers
# dpsa = all containers, including stopped/crashed ones
# di   = local Docker images
# dv   = Docker volumes, often used by databases
# dn   = Docker networks
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dv="docker volume ls"
alias dn="docker network ls"

# Docker Compose workflow.
# dcu  = start services in background
# dcub = rebuild images and start services
# dcd  = stop/remove compose containers, keeps volumes
# dcdv = stop/remove compose containers AND volumes
# dcl  = follow compose logs
# dcps = show compose services in current project
alias dcu="docker compose up -d"
alias dcub="docker compose up -d --build"
alias dcd="docker compose down"

# WARNING:
# Deletes Compose volumes for the current project.
# This can delete local Postgres/MySQL/Redis data for that project.
# Use only when you want a clean database reset.
alias dcdv="docker compose down -v"

alias dcl="docker compose logs -f"
alias dcb="docker compose build"
alias dcr="docker compose restart"
alias dcps="docker compose ps"

# Docker cleanup.
# dprune  = safe-ish cleanup; does NOT remove volumes by default
# dnprune = remove unused networks
# dvprune = remove unused volumes; be careful with database data
alias dprune="docker system prune"

# WARNING:
# Removes unused Docker volumes.
# Volumes often contain database data.
alias dvprune="docker volume prune"

alias dnprune="docker network prune"