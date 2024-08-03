# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
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
ZSH_THEME="./powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git zsh-autosuggestions)
export LS_COLORS='rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:'

source $ZSH/oh-my-zsh.sh
#source ~/.zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a3a3a3,underline"
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
# ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
# ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
# ZSH_HIGHLIGHT_STYLES[command]='fg=cyan'
# ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=cyan'
# ZSH_HIGHLIGHT_STYLES[path]='fg=yellow'
# ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
# ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=orange'
# ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=blue,bold'
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=blue,bold'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
# ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
# ZSH_HIGHLIGHT_STYLES[assign]='fg=red'
#
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "$HOME/.cargo/env"

# golang
export PATH=$PATH:/usr/local/go/bin

# diff-so-fancy
export PATH=$PATH:$HOME/var/diff-so-fancy

# cpt
export ENV=$ENV/.env

# for tmux utf-8 support
export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8

function yz() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias zl="zellij --layout ~/.config/zellij/layout.kdl"
alias lz="lazygit"
alias tmux='TERM=screen-256color tmux'
alias fzf="fzf --preview 'bat --style=numbers --color=always {}'"
alias fd="fdfind"
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules'

alias ls="eza --color=always --long --git --icons=always --no-permissions"
alias ll="eza --color=always --long --git --icons=always --no-permissions"
alias cat="bat"
alias z="~/.local/bin/zoxide"

if [[ $(ps --no-header -p $PPID -o comm) =~ '^alacritty$' ]]; then
        for wid in $(xdotool search --pid $PPID); do
            xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
fi

export LS_COLORS="$(vivid generate molokai)"

eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
