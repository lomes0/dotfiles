if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi

# Optimized completion initialization
autoload -Uz compinit
# Check if completion dump is older than 24 hours
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C  # Skip security check for faster startup
fi

# Skip alias verification for faster completion
setopt no_global_rcs
# Reduce zsh history overhead during startup
setopt hist_verify
setopt hist_no_store
autoload -Uz bashcompinit && bashcompinit

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates for faster startup
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
#
# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
CASE_SENSITIVE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Optimized plugin loading - lighter plugins first
# zsh-vi-mode
plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration
#
# source "$HOME/.cargo/env"

# PATH management - prepend user directories for priority
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/var/diff-so-fancy:$PATH"
export PATH=$PATH:/usr/local/go/bin

function yz() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# alias
alias zl="zellij --layout ~/.config/zellij/layout.kdl"
alias lz="lazygit"
alias tmux='TERM=screen-256color tmux'
# alias fzf="fzf --preview 'bat --style=numbers --color=always {}'"
# export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules'
alias nv=nvim

export DELTA_FEATURES='+side-by-side my-feature'
alias ls="eza --sort=type --color=always --long --git --icons=always --no-permissions --ignore-glob=ctxmnt"
alias ll="eza --sort=type --color=always --long --git --icons=always --no-permissions --ignore-glob=ctxmnt"
alias cat="bat"
# alias z="~/.local/bin/zoxide"

# eza colors
export EZA_COLORS="di=1;38;5;109:\
fi=38;5;250:\
ln=1;38;5;74:\
pi=38;5;181:\
so=1;38;5;215:\
bd=1;38;5;216;48;5;237:\
cd=1;38;5;174;48;5;237:\
ex=1;38;5;114:\
da=38;5;110:\
uu=38;5;131:\
ro=38;5;131:\
mi=38;5;139:\
tw=38;5;132:\
ow=1;38;5;139:\
cl=38;5;248"

export ZSH_HIGHLIGHT_STYLES[comment]='fg=gray,dimmed'
export ZSH_HIGHLIGHT_STYLES[command]='fg=#a1ccbc,bold'
export ZSH_HIGHLIGHT_STYLES[default]='fg=#cccecf'
export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#eceaa9,bold'
export ZSH_HIGHLIGHT_STYLES[builtin]='fg=#9dc1ed,bold'
export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e0e0de'
export ZSH_HIGHLIGHT_STYLES[alias]='fg=#af99ba,bold'
export ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a7cbcc'
export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#a5acb8,bold'
export ZSH_HIGHLIGHT_STYLES[path]='fg=#e9f5ef,underline'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# default,unknown-token,reserved-word,alias,builtin,function,command,hashed-command,precommand,commandseparator,
# autodirectory,path,globbing,history-expansion,single-hyphen-option,double-hyphen-option,back-quoted-argument,
# single-quoted-argument,double-quoted-argument,dollar-double-quoted-argument,back-double-quoted-argument,assign,
# redirection,comment,named-fd,arg0,bold,faint,standout,underline,blink,no-bold,no-faint,no-standout,no-underline,no-blink,reset
# black, red, green, yellow, blue, magenta, cyan, white

# Using EZA_COLORS instead - LS_COLORS removed to reduce bloat

# autoload -U promptinit; promptinit
# prompt pure

export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8
export LANGUAGE=en_IN.UTF-8

eval "$(starship init zsh)"

fpath=(~/.zsh/completions $fpath)

export PATH="${CARGO_HOME}/bin:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.deno/env"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# eval "$(tv init zsh)"
#
# source $HOME/.config/television/shell/integration.zsh

export PATH="$PATH:$HOME/var/llvm/llvm-20.1.8-build/bin"

alias load_npm="source .env && source ~/.nvm/nvm.sh"
alias stop_blog_service="sudo systemctl stop blog-simple.service"
alias start_blog_service="sudo systemctl start blog-simple.service"

eval "$(zoxide init zsh)"
