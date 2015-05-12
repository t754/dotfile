# ~/.bashrc 
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

[ -r $HOME/.aliasrc ] && . $HOME/.aliasrc
# set -x
export TERM="xterm-256color"
export COLORTERM="mlterm"
export EDITOR="emacsclient -nw"
export ALTERNATE_EDITOR=""
export PAGER="less"
export LESS=' -R'
export LESS_TERMCAP_mb=$'\E[01;31m' 
export LESS_TERMCAP_md=$'\E[01;38;5;74m' 
export LESS_TERMCAP_me=$'\E[0m' 
export LESS_TERMCAP_se=$'\E[0m' 
# export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_so=$'\E[01;33;03;40m'
export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_ue=$'\E[0m' 
export LESS_TERMCAP_us=$'\E[04;38;5;146m' 
if type src-hilite-lesspipe.sh  >/dev/null 2>&1 ; then
    export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
fi    
export VISUAL="emacs"
export BROWSER="firefox"
export TZ="JST+15"
export LC_MESSAGES="C"
# 重複服歴を無視
# export HISTCONTROL=ignoredups
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend


# ${PROMPT_COMMAND:$PROMPT_COMMAND$'\n'}
export PROMPT_COMMAND=" history -a; history -c; history -r;"

export HISTIGNORE="fg*:bg*:history*:rm*:ls"
export HISTSIZE=10000 # C-r C-s　で履歴を検索できるらしい

# export COLORTERM="mlterm"
if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi
export GOPATH="$HOME/.go"

export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH="$HOME/bin:$PATH:/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.cabal/bin/:$HOME/.cask/bin:$GOPATH/bin:$HOME/.rbenv/bin:$HOME/.gem/ruby/2.0.0/bin:$HOME/.gem/ruby/2.2.0/bin:$HOME/.gem/ruby/2.1.0/bin:/usr/bin/vendor_perl"
export LD_LIBRARY_PATH="/lib:/lib64:/usr/lib64:/usr/lib32:/usr/lib:/usr/local/lib"
export LDFLAGS=""
# SCREEN buffer
export SCREENEXCHANGE="/tmp/screen-exchange"
export IGNOREEOF=1
stty stop undef
export MANPATH=/usr/share/man/ja:
export _Z_CMD=z
[ -r ~/.ghq/github.com/rupa/z/z.sh ] && source ~/.ghq/github.com/rupa/z/z.sh



[ -r $HOME/.tmuxinator/tmuxinator.bash ] && . $HOME/.tmuxinator/tmuxinator.bash




function Cl() {
	echo $@ | xsel --input --clipboard
}

function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


# function extract() {
#     local c e i
#     (($#)) || return
#     for i; do
#         c=''
#         e=1
#         if [[ ! -r $i ]]; then
# 			echo "$0: file is unreadable: \`$i'" >&2
#             continue
#         fi
#         case $i in
#             *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz))))) c='tar xvf';; # 
#             *.7z)  c='7z x';;
#             *.Z)   c='uncompress';;
#             *.bz2) c='bunzip2';;
#             *.exe) c='cabextract';;
#             *.gz)  c='gunzip';;
#             *.rar) c='unrar x';;
#             *.xz)  c='unxz';;
#             *.zip) c='unzip';;
#             *.lzh) c='lha x';;
#             *)     echo "$0: unrecognized file extension: \`$i'" >&2
#             continue;;
#         esac
#         command $c "$i"
#         e=$?
#     done
#     return $e
# }

function EC() { echo -e '\e[1;33m'code $?'\e[m'; }
trap EC ERR

ulimit -c 4096

export PYTHONSTARTUP=$HOME/.pythonrc.py


function colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"


    # foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

#  or flat

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export POWERSHELL_MODE="flat"
else
    export POWERSHELL_MODE="patched"
fi
function _update_ps1() {
    export PS1="$(~/powerline-shell.py --mode ${POWERSHELL_MODE} --shell bash $? 2> /dev/null)"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")';
}
PROMPT_COMMAND="  _update_ps1 ; $PROMPT_COMMAND"

complete -cf sudo
complete -cf man

# function ipif() { 
#     if \grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
# 	curl ipinfo.io/"$1"
#     else
# 	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
# 	curl ipinfo.io/${ipawk[1]}
#     fi
#     echo
# }



function peco-select-history () {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
if [ -x "`which peco`" ]; then
bind -x '"\C-r": peco-select-history'
bind    '"\C-xr": reverse-search-history'
fi

if [ -x "`which ag`" ]; then
function peco-ag () {
    ag $@ | peco --query "$READLINE_LINE" | awk -F : '{print "+" $2 " " $1}' | xargs emacsclient -c
}

fi

function j() {
    if [ $# -eq 0 ] ; then
        cd $(z | tac | awk "{print \$2}" | peco)
    else
        z $*
    fi
}
function lll() {
    ls -a1 $* |  peco
}
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[01;33;03;40m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}


if [ "x${WINDOWID}" != "x" ] ; then
    if [ -x "`which keychain`" ]; then
        eval $(keychain --eval --nogui -Q -q --agents ssh id_rsa.bit id_rsa)
    fi
fi
