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
alias functions="code ~/.oh-my-zsh/custom/functions.zsh"
alias completions="code ~/.oh-my-zsh/custom/completions.zsh"

alias path='echo $PATH | tr ":" "\n"'

alias bdump="brewdump"

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

# Open finder directory in terminal.
alias fdhere="finder"

# ─────────────────────────────
# 🚀 Flutter / Dart (via FVM)
# ─────────────────────────────

# Use FVM-managed Flutter and Dart by default.
alias f="fvm flutter"
alias fd="fvm dart"

# Direct local project Flutter binary.
# Use only inside a repo that contains .fvm/flutter_sdk.
alias fv=".fvm/flutter_sdk/bin/flutter"

# Common Flutter maintenance shortcuts.
alias frefresh="f clean && f pub get"
alias fbuildrunner="f pub run build_runner build --delete-conflicting-outputs"
alias fwatchrunner="f pub run build_runner watch --delete-conflicting-outputs"
alias fdoctor="f doctor"
alias flog="f logs"

# ─────────────────────────────
# ⚛ React Native
# ─────────────────────────────

# Connect Android device over Wi-Fi debugging.
# Update the IP if your device IP changes.
alias rnwifi='adb kill-server && adb tcpip 5555 && adb connect 192.168.0.105:5555 && adb devices'

# Aggressively reset a React Native project.
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
alias test="pn test"

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

# Update and clean Homebrew.
alias update="brew update && brew upgrade && brew autoremove && brew cleanup -s"

# Quick CPU / RAM inspection.
alias topmem="ps aux | sort -nr -k 4 | head -15"
alias topcpu="ps aux | sort -nr -k 3 | head -15"
alias ram="top -o mem"
alias cpu="top -o cpu"

# Disk usage helpers.
alias du1="du -d 1 -h . | sort -h"
alias trashsize="du -sh ~/.Trash"
alias emptytrash="rm -rf ~/.Trash/*"

# Better system monitor.
alias bt="btop"

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

# Interactive live grep.
alias fg="fglive"

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