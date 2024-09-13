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
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#
# User configuration
#
source "$HOME/.cargo/env"

# golang
export PATH=$PATH:/usr/local/go/bin

# diff-so-fancy
export PATH=$PATH:$HOME/var/diff-so-fancy

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

# alias
alias zl="zellij --layout ~/.config/zellij/layout.kdl"
alias lz="lazygit"
alias tmux='TERM=screen-256color tmux'
alias fzf="fzf --preview 'bat --style=numbers --color=always {}'"
alias fd="fdfind"
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules'

alias ls="eza --color=always --long --git --icons=always --no-permissions --ignore-glob=ctxmnt"
alias ll="eza --color=always --long --git --icons=always --no-permissions --ignore-glob=ctxmnt"
alias cat="bat"
alias z="~/.local/bin/zoxide"

export ZSH_HIGHLIGHT_STYLES[comment]='fg=gray,dimmed'
export LS_COLORS="$(vivid generate nord)"

eval "$(starship init zsh)"

if [[ $(ps --no-header -p $PPID -o comm) =~ '^alacritty$' ]]; then
	for wid in $(xdotool search --pid $PPID); do
		xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid;
	done
fi

# # pnpm
# export PNPM_HOME="/home/eransa/.local/share/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# # pnpm end
