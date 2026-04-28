# # If you come from bash you might have to change your $PATH.
# # export PATH=$HOME/bin:/usr/local/bin:$PATH

# # Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# # Set name of the theme to load --- if set to "random", it will
# # load a random theme each time oh-my-zsh is loaded, in which case,
# # to know which specific one was loaded, run: echo $RANDOM_THEME
# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# # Set list of themes to pick from when loading at random
# # Setting this variable when ZSH_THEME=random will cause zsh to load
# # a theme from this variable instead of looking in $ZSH/themes/
# # If set to an empty array, this variable will have no effect.
# # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# # Uncomment the following line to use case-sensitive completion.
# # CASE_SENSITIVE="true"

# # Uncomment the following line to use hyphen-insensitive completion.
# # Case-sensitive completion must be off. _ and - will be interchangeable.
# # HYPHEN_INSENSITIVE="true"

# # Uncomment one of the following lines to change the auto-update behavior
# # zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# # zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# # Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 10

# # Uncomment the following line if pasting URLs and other text is messed up.
# # DISABLE_MAGIC_FUNCTIONS="true"

# # Uncomment the following line to disable colors in ls.
# # DISABLE_LS_COLORS="true"

# # Uncomment the following line to disable auto-setting terminal title.
# # DISABLE_AUTO_TITLE="true"

# # Uncomment the following line to enable command auto-correction.
# # ENABLE_CORRECTION="true"

# # Uncomment the following line to display red dots whilst waiting for completion.
# # You can also set it to another string to have that shown instead of the default red dots.
# # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# # COMPLETION_WAITING_DOTS="true"

# # Uncomment the following line if you want to disable marking untracked files
# # under VCS as dirty. This makes repository status check for large repositories
# # much, much faster.
# # DISABLE_UNTRACKED_FILES_DIRTY="true"

# # Uncomment the following line if you want to change the command execution time
# # stamp shown in the history command output.
# # You can set one of the optional three formats:
# # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# # or set a custom format using the strftime function format specifications,
# # see 'man strftime' for details.
# HIST_STAMPS="yyyy-mm-dd"

# # Handling duplicate commands.
# # this will skip duplicates and show it only once 
# setopt HIST_FIND_NO_DUPS
# # this will avoid writing duplicates to history in the first place. this is already set in ohmyzsh
# setopt HIST_IGNORE_ALL_DUPS 

# # Would you like to use another custom folder than $ZSH/custom?
# # ZSH_CUSTOM=/path/to/new-custom-folder

# # Shell setup for FNM
# eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# # Which plugins would you like to load?
# # Standard plugins can be found in $ZSH/plugins/
# # Custom plugins may be added to $ZSH_CUSTOM/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# # plugins=(z git zsh-autosuggestions zsh-syntax-highlighting)
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# source $ZSH/oh-my-zsh.sh

# # User configuration

# # export MANPATH="/usr/local/man:$MANPATH"

# # You may need to manually set your language environment
# # export LANG=en_US.UTF-8

# # Preferred editor for local and remote sessions
# # if [[ -n $SSH_CONNECTION ]]; then
# #   export EDITOR='vim'
# # else
# #   export EDITOR='mvim'
# # fi

# # Compilation flags
# # export ARCHFLAGS="-arch x86_64"

# # Starship prompt
# eval "$(starship init zsh)"

# # Set personal aliases, overriding those provided by oh-my-zsh libs,
# # plugins, and themes. Aliases can be placed here, though oh-my-zsh
# # users are encouraged to define aliases within the ZSH_CUSTOM folder.
# # For a full list of active aliases, run `alias`.
# #
# # Example aliases
# # Loaded aliases can be found in the `aliases.zsh` file. in the custom folder.

# # fig alias migration

# # kill all processes at port (port being the input)
# # kill $(lsof -t -i:{{port}})

# # Forward port local to remote
# # ssh -L {{local_port}}:localhost:{{remote_port}} {{username}}@{{ip}}

# # git commit
# # get user input for message, and give select from list of options for branch (list local branches, list branches) and type (feat, fix, refactor, style, test, chore)
# # git add .
# # git commit -m '{{type}}: {{msg}}'
# # git push origin {{branch}}

# # pnpm
# # export PNPM_HOME="/Users/mugilan/Library/pnpm"
# # export PATH="$PNPM_HOME:$PATH"
# # pnpm end

# # React Native
# # ruby for ios
# # eval "$(rbenv init - zsh)"
# # React Native end

# # Rbenv configs
# # export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
# # export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

# # export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# # tabtab source for packages
# # uninstall by removing these lines
# [[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# # bun completions
# [ -s "/Users/mugilan/.bun/_bun" ] && source "/Users/mugilan/.bun/_bun"

# # Load Angular CLI autocompletion.
# # source <(ng completion script)

# ## [Completion]
# ## Completion scripts setup. Remove the following line to uninstall
# [[ -f /Users/mugilan/.dart-cli-completion/zsh-config.zsh ]] && . /Users/mugilan/.dart-cli-completion/zsh-config.zsh || true
# ## [/Completion]

# # # fnm
# # FNM_PATH="/Users/mugilan/Library/Application Support/fnm"
# # if [ -d "$FNM_PATH" ]; then
# #   export PATH="/Users/mugilan/Library/Application Support/fnm:$PATH"
# #   eval "`fnm env`"
# # fi

# source <(fzf --zsh)
# eval "$(zoxide init zsh)"

# # The following lines have been added by Docker Desktop to enable Docker CLI completions.
# fpath=(/Users/mugilan/.docker/completions $fpath)
# autoload -Uz compinit
# compinit
# # End of Docker CLI completions

# ====== REMOVE ABOVE LINES ======

# ~/.zshrc
# Loaded for interactive shells.
# Keep shell behavior, prompt, plugins, aliases, functions, and completions here.

# Stop early for non-interactive shells.
[[ $- != *i* ]] && return

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Oh My Zsh updates
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 10

# History
HIST_STAMPS="yyyy-mm-dd"
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Add Docker CLI completions before loading Oh My Zsh.
# Add neatCLI completions in .zfunc
# Oh My Zsh will initialize completions for us.
fpath=("$HOME/.docker/completions" "$HOME/.zfunc" $fpath)

# FNM
# Auto-switch Node.js versions based on .nvmrc / .node-version files.
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# Default editor (Change to nvim if neovim is preferred and available)
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Prompt
eval "$(starship init zsh)"

# Interactive tooling
source <(fzf --zsh)
eval "$(zoxide init zsh)"

# Custom aliases, functions, and completions
source "$ZSH/custom/aliases.zsh"
source "$ZSH/custom/functions.zsh"
source "$ZSH/custom/completions.zsh"