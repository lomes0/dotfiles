# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/eransa/.zsh/completions:"* ]]; then export FPATH="/home/eransa/.zsh/completions:$FPATH"; fi
# zmodload zsh/zprof

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
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

#
# User configuration
#
# source "$HOME/.cargo/env"

# local bin
export PATH=$PATH:$HOME/.local/bin

export PATH=$PATH:$HOME/.cargo/bin

# diff-so-fancy
export PATH=$PATH:$HOME/var/diff-so-fancy

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
export EZA_COLORS="\                                                                                                                                                                                                                   archlinux 
di=1;38;5;109:\
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
# default,unknown-token,reserved-word,alias,builtin,function,command,hashed-command,precommand,commandseparator,
# autodirectory,path,globbing,history-expansion,single-hyphen-option,double-hyphen-option,back-quoted-argument,
# single-quoted-argument,double-quoted-argument,dollar-double-quoted-argument,back-double-quoted-argument,assign,
# redirection,comment,named-fd,arg0,bold,faint,standout,underline,blink,no-bold,no-faint,no-standout,no-underline,no-blink,reset
# black, red, green, yellow, blue, magenta, cyan, white

# export LS_COLORS="$(vivid generate nord)"
export LS_COLORS="di=1;38;2;143;188;187:ca=0:or=1;38;2;236;239;244;48;2;191;97;106:cd=1;38;2;235;203;139;48;2;67;76;94:ln=1;38;2;163;190;140:sg=0:do=1;38;2;180;142;173;48;2;67;76;94:pi=1;38;2;235;203;139;48;2;67;76;94:tw=0:no=0;38;2;76;86;106:*~=0;38;2;67;76;94:mh=0:st=0:so=1;38;2;180;142;173;48;2;67;76;94:su=0:ex=1;38;2;208;135;112:fi=0;38;2;76;86;106:rs=0;38;2;76;86;106:bd=1;38;2;235;203;139;48;2;67;76;94:ow=0:mi=1;38;2;236;239;244;48;2;191;97;106:*.a=0;38;2;208;135;112:*.c=0;38;2;163;190;140:*.r=0;38;2;163;190;140:*.d=0;38;2;163;190;140:*.h=0;38;2;163;190;140:*.t=0;38;2;163;190;140:*.z=1;38;2;129;161;193:*.m=0;38;2;163;190;140:*.o=0;38;2;67;76;94:*.p=0;38;2;163;190;140:*.di=0;38;2;163;190;140:*.hh=0;38;2;163;190;140:*css=0;38;2;163;190;140:*.ex=0;38;2;163;190;140:*.pm=0;38;2;163;190;140:*.js=0;38;2;163;190;140:*.td=0;38;2;163;190;140:*.cp=0;38;2;163;190;140:*.cs=0;38;2;163;190;140:*.el=0;38;2;163;190;140:*.la=0;38;2;67;76;94:*.7z=1;38;2;129;161;193:*.lo=0;38;2;67;76;94:*.gv=0;38;2;163;190;140:*.bz=1;38;2;129;161;193:*.ll=0;38;2;163;190;140:*.hs=0;38;2;163;190;140:*.go=0;38;2;163;190;140:*.ts=0;38;2;163;190;140:*.xz=1;38;2;129;161;193:*.ps=0;38;2;180;142;173:*.rm=0;38;2;180;142;173:*.so=0;38;2;208;135;112:*.nb=0;38;2;163;190;140:*.ml=0;38;2;163;190;140:*.pl=0;38;2;163;190;140:*.py=0;38;2;163;190;140:*.pp=0;38;2;163;190;140:*.rb=0;38;2;163;190;140:*.mn=0;38;2;163;190;140:*.fs=0;38;2;163;190;140:*.wv=0;38;2;180;142;173:*.as=0;38;2;163;190;140:*.ko=0;38;2;208;135;112:*.cc=0;38;2;163;190;140:*.sh=0;38;2;163;190;140:*.bc=0;38;2;67;76;94:*.hi=0;38;2;67;76;94:*.rs=0;38;2;163;190;140:*.vb=0;38;2;163;190;140:*.kt=0;38;2;163;190;140:*.gz=1;38;2;129;161;193:*.cr=0;38;2;163;190;140:*.md=0;38;2;180;142;173:*.ui=0;38;2;180;142;173:*.jl=0;38;2;163;190;140:*.doc=0;38;2;180;142;173:*.ppt=0;38;2;180;142;173:*.mkv=0;38;2;180;142;173:*TODO=1;38;2;180;142;173:*.vob=0;38;2;180;142;173:*.zst=1;38;2;129;161;193:*.cfg=0;38;2;180;142;173:*.ps1=0;38;2;163;190;140:*.sxw=0;38;2;180;142;173:*.rpm=1;38;2;129;161;193:*.tex=0;38;2;163;190;140:*.jpg=0;38;2;180;142;173:*.dpr=0;38;2;163;190;140:*.m4v=0;38;2;180;142;173:*.fon=0;38;2;180;142;173:*.nix=0;38;2;180;142;173:*.mp4=0;38;2;180;142;173:*.odp=0;38;2;180;142;173:*.gif=0;38;2;180;142;173:*.erl=0;38;2;163;190;140:*.img=1;38;2;129;161;193:*.bag=1;38;2;129;161;193:*.fsx=0;38;2;163;190;140:*.htc=0;38;2;163;190;140:*.apk=1;38;2;129;161;193:*.bak=0;38;2;67;76;94:*.swp=0;38;2;67;76;94:*.txt=0;38;2;180;142;173:*.fsi=0;38;2;163;190;140:*.aux=0;38;2;67;76;94:*hgrc=0;38;2;163;190;140:*.swf=0;38;2;180;142;173:*.blg=0;38;2;67;76;94:*.vcd=1;38;2;129;161;193:*.ppm=0;38;2;180;142;173:*.out=0;38;2;67;76;94:*.rst=0;38;2;180;142;173:*.cxx=0;38;2;163;190;140:*.wma=0;38;2;180;142;173:*.htm=0;38;2;180;142;173:*.png=0;38;2;180;142;173:*.kts=0;38;2;163;190;140:*.avi=0;38;2;180;142;173:*.ipp=0;38;2;163;190;140:*.rar=1;38;2;129;161;193:*.clj=0;38;2;163;190;140:*.bz2=1;38;2;129;161;193:*.m4a=0;38;2;180;142;173:*.bbl=0;38;2;67;76;94:*.odt=0;38;2;180;142;173:*.jar=1;38;2;129;161;193:*.mid=0;38;2;180;142;173:*.pkg=1;38;2;129;161;193:*.psd=0;38;2;180;142;173:*.sql=0;38;2;163;190;140:*.svg=0;38;2;180;142;173:*.bsh=0;38;2;163;190;140:*.dmg=1;38;2;129;161;193:*.gvy=0;38;2;163;190;140:*.ics=0;38;2;180;142;173:*.dll=0;38;2;208;135;112:*.sbt=0;38;2;163;190;140:*.h++=0;38;2;163;190;140:*.eps=0;38;2;180;142;173:*.tgz=1;38;2;129;161;193:*.sxi=0;38;2;180;142;173:*.xmp=0;38;2;180;142;173:*.hpp=0;38;2;163;190;140:*.bmp=0;38;2;180;142;173:*.ico=0;38;2;180;142;173:*.csx=0;38;2;163;190;140:*.iso=1;38;2;129;161;193:*.tcl=0;38;2;163;190;140:*.elm=0;38;2;163;190;140:*.rtf=0;38;2;180;142;173:*.xml=0;38;2;180;142;173:*.pid=0;38;2;67;76;94:*.def=0;38;2;163;190;140:*.cgi=0;38;2;163;190;140:*.xls=0;38;2;180;142;173:*.fls=0;38;2;67;76;94:*.ogg=0;38;2;180;142;173:*.tbz=1;38;2;129;161;193:*.pgm=0;38;2;180;142;173:*.sty=0;38;2;67;76;94:*.ind=0;38;2;67;76;94:*.exs=0;38;2;163;190;140:*.yml=0;38;2;180;142;173:*.pdf=0;38;2;180;142;173:*.tif=0;38;2;180;142;173:*.flv=0;38;2;180;142;173:*.zip=1;38;2;129;161;193:*.log=0;38;2;67;76;94:*.dox=0;38;2;163;190;140:*.php=0;38;2;163;190;140:*.csv=0;38;2;180;142;173:*.pbm=0;38;2;180;142;173:*.hxx=0;38;2;163;190;140:*.idx=0;38;2;67;76;94:*.bcf=0;38;2;67;76;94:*.awk=0;38;2;163;190;140:*.inl=0;38;2;163;190;140:*.lua=0;38;2;163;190;140:*.tml=0;38;2;180;142;173:*.ltx=0;38;2;163;190;140:*.vim=0;38;2;163;190;140:*.xcf=0;38;2;180;142;173:*.aif=0;38;2;180;142;173:*.arj=1;38;2;129;161;193:*.com=0;38;2;208;135;112:*.epp=0;38;2;163;190;140:*.mov=0;38;2;180;142;173:*.pps=0;38;2;180;142;173:*.pro=0;38;2;163;190;140:*.tar=1;38;2;129;161;193:*.deb=1;38;2;129;161;193:*.ttf=0;38;2;180;142;173:*.inc=0;38;2;163;190;140:*.tmp=0;38;2;67;76;94:*.c++=0;38;2;163;190;140:*.pod=0;38;2;163;190;140:*.zsh=0;38;2;163;190;140:*.xlr=0;38;2;180;142;173:*.ods=0;38;2;180;142;173:*.mp3=0;38;2;180;142;173:*.ini=0;38;2;180;142;173:*.mir=0;38;2;163;190;140:*.cpp=0;38;2;163;190;140:*.mli=0;38;2;163;190;140:*.wmv=0;38;2;180;142;173:*.bin=1;38;2;129;161;193:*.bib=0;38;2;180;142;173:*.bst=0;38;2;180;142;173:*.asa=0;38;2;163;190;140:*.dot=0;38;2;163;190;140:*.git=0;38;2;67;76;94:*.ilg=0;38;2;67;76;94:*.fnt=0;38;2;180;142;173:*.exe=0;38;2;208;135;112:*.pyd=0;38;2;67;76;94:*.tsx=0;38;2;163;190;140:*.bat=0;38;2;208;135;112:*.pyo=0;38;2;67;76;94:*.wav=0;38;2;180;142;173:*.otf=0;38;2;180;142;173:*.toc=0;38;2;67;76;94:*.mpg=0;38;2;180;142;173:*.pyc=0;38;2;67;76;94:*.pas=0;38;2;163;190;140:*.kex=0;38;2;180;142;173:*.epub=0;38;2;180;142;173:*.diff=0;38;2;163;190;140:*.lock=0;38;2;67;76;94:*.html=0;38;2;180;142;173:*.purs=0;38;2;163;190;140:*.mpeg=0;38;2;180;142;173:*.rlib=0;38;2;67;76;94:*.json=0;38;2;180;142;173:*.psd1=0;38;2;163;190;140:*.make=0;38;2;163;190;140:*.docx=0;38;2;180;142;173:*.tiff=0;38;2;180;142;173:*.flac=0;38;2;180;142;173:*.orig=0;38;2;67;76;94:*.less=0;38;2;163;190;140:*.opus=0;38;2;180;142;173:*.pptx=0;38;2;180;142;173:*.toml=0;38;2;180;142;173:*.dart=0;38;2;163;190;140:*.h264=0;38;2;180;142;173:*.jpeg=0;38;2;180;142;173:*.fish=0;38;2;163;190;140:*.yaml=0;38;2;180;142;173:*.conf=0;38;2;180;142;173:*.lisp=0;38;2;163;190;140:*.hgrc=0;38;2;163;190;140:*.java=0;38;2;163;190;140:*.webm=0;38;2;180;142;173:*.tbz2=1;38;2;129;161;193:*.psm1=0;38;2;163;190;140:*.bash=0;38;2;163;190;140:*.xlsx=0;38;2;180;142;173:*.swift=0;38;2;163;190;140:*.ipynb=0;38;2;163;190;140:*.mdown=0;38;2;180;142;173:*.dyn_o=0;38;2;67;76;94:*.class=0;38;2;67;76;94:*.cmake=0;38;2;163;190;140:*passwd=0;38;2;180;142;173:*.shtml=0;38;2;180;142;173:*.cabal=0;38;2;163;190;140:*.toast=1;38;2;129;161;193:*shadow=0;38;2;180;142;173:*.xhtml=0;38;2;180;142;173:*.cache=0;38;2;67;76;94:*.scala=0;38;2;163;190;140:*README=0;38;2;180;142;173:*.patch=0;38;2;163;190;140:*.config=0;38;2;180;142;173:*.gradle=0;38;2;163;190;140:*.matlab=0;38;2;163;190;140:*.flake8=0;38;2;163;190;140:*.dyn_hi=0;38;2;67;76;94:*COPYING=0;38;2;180;142;173:*.groovy=0;38;2;163;190;140:*INSTALL=0;38;2;180;142;173:*TODO.md=1;38;2;180;142;173:*LICENSE=0;38;2;180;142;173:*.ignore=0;38;2;163;190;140:*.desktop=0;38;2;180;142;173:*setup.py=0;38;2;163;190;140:*Doxyfile=0;38;2;163;190;140:*.gemspec=0;38;2;163;190;140:*TODO.txt=1;38;2;180;142;173:*Makefile=0;38;2;163;190;140:*configure=0;38;2;163;190;140:*.rgignore=0;38;2;163;190;140:*.cmake.in=0;38;2;163;190;140:*.kdevelop=0;38;2;163;190;140:*.markdown=0;38;2;180;142;173:*.fdignore=0;38;2;163;190;140:*COPYRIGHT=0;38;2;180;142;173:*.DS_Store=0;38;2;67;76;94:*README.md=0;38;2;180;142;173:*Dockerfile=0;38;2;180;142;173:*.gitignore=0;38;2;163;190;140:*SConstruct=0;38;2;163;190;140:*.localized=0;38;2;67;76;94:*.gitconfig=0;38;2;163;190;140:*.scons_opt=0;38;2;67;76;94:*SConscript=0;38;2;163;190;140:*CODEOWNERS=0;38;2;163;190;140:*INSTALL.md=0;38;2;180;142;173:*README.txt=0;38;2;180;142;173:*.travis.yml=0;38;2;163;190;140:*Makefile.am=0;38;2;163;190;140:*.gitmodules=0;38;2;163;190;140:*MANIFEST.in=0;38;2;163;190;140:*INSTALL.txt=0;38;2;180;142;173:*Makefile.in=0;38;2;67;76;94:*LICENSE-MIT=0;38;2;180;142;173:*.synctex.gz=0;38;2;67;76;94:*configure.ac=0;38;2;163;190;140:*CONTRIBUTORS=0;38;2;180;142;173:*appveyor.yml=0;38;2;163;190;140:*.fdb_latexmk=0;38;2;67;76;94:*.applescript=0;38;2;163;190;140:*.clang-format=0;38;2;163;190;140:*CMakeLists.txt=0;38;2;163;190;140:*CMakeCache.txt=0;38;2;67;76;94:*LICENSE-APACHE=0;38;2;180;142;173:*.gitattributes=0;38;2;163;190;140:*CONTRIBUTORS.md=0;38;2;180;142;173:*CONTRIBUTORS.txt=0;38;2;180;142;173:*requirements.txt=0;38;2;163;190;140:*.sconsign.dblite=0;38;2;67;76;94:*package-lock.json=0;38;2;67;76;94:*.CFUserTextEncoding=0;38;2;67;76;94"

# autoload -U promptinit; promptinit
# prompt pure

export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8
export LANGUAGE=en_IN.UTF-8

eval "$(starship init zsh)"

# fpath=(~/.zsh/completions $fpath)
# autoload -U compinit
# compinit

export PATH=$CARGO_HOME/bin:$PATH

# zprof

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "/home/eransa/.deno/env"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
