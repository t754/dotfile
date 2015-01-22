# ~/.bashrc
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

[ -r $HOME/.aliasrc ] && . $HOME/.aliasrc

export TERM="xterm-256color"
# export COLORTERM="mlterm"
export EDITOR="emacsclient -nw"
export ALTERNATE_EDITOR=""
export PAGER="less"
export LESS='-R'

export VISUAL="emacs"
export BROWSER="firefox"
export TZ="JST"
export LC_MESSAGES="C"
# 重複服歴を無視
# export HISTCONTROL=ignoredups
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# echo  ${PROMPT_COMMAND:?aaaaaaaaaaaaa}
# ${PROMPT_COMMAND:$PROMPT_COMMAND$'\n'}
export PROMPT_COMMAND=" history -a; history -c; history -r;"

export HISTIGNORE="fg*:bg*:history*:rm*"
export HISTSIZE=10000 # C-r C-s　で履歴を検索できるらしい

# export COLORTERM="mlterm"
if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi
export GOPATH="$HOME/.go"

export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH="$HOME/bin:$PATH:/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.cabal/bin/:$HOME/.gem/ruby/2.0.0/bin:$HOME/.gem/ruby/2.1.0/bin:$HOME/.cask/bin:$GOPATH/bin:$HOME/.rbenv/bin"
export LD_LIBRARY_PATH="/lib:/lib64:/usr/lib64:/usr/lib32:/usr/lib:/usr/local/lib"
export LDFLAGS=""
# SCREEN buffer
export SCREENEXCHANGE="/tmp/screen-exchange"
export IGNOREEOF=1
stty stop undef

export _Z_CMD=z
source ~/bin/z.sh
#
source ~/.tmuxinator/tmuxinator.bash

function Cl(){
	echo $@ | xsel --input --clipboard
}

function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


# function uuuu {
# 	/usr/bin/sensors 2> /dev/null | awk '"Core" == $1 { i += int($3); n++} END{ printf( "%d",i/n) }'
# }

# function mmmm {
# 	free | awk '/^\-\/\+/{ printf("\033[1;42;37m%05.2f\033[0m ",$3/($3+$4)*100) } /^Swap/{printf("\033[1;44;37m%05.2f\033[0m",$3/$2*100) }'
# }


# function proml {
# 	export PS1="\e[41m \e[0m\e[1;32m\@\e[0m \e[1;105;93m\w\e[0m \e[41m \e[0m\j\e[0m
# \e[41m \e[0m \e[1;47;34m\u\e[1;93;104m\h\e[0m\e[1;35m\$(parse_git_branch) \e[0m\
# \e[0m\$(uuuu)'C \$(mmmm) \e[41m \e[0m
# \\$>"
# }
# proml


function extract() {
    local c e i
    (($#)) || return
    for i; do
        c=''
        e=1
        if [[ ! -r $i ]]; then
			echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi
        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz))))) c='bsdtar xvf';; # 
            *.7z)  c='7z x';;
            *.Z)   c='uncompress';;
            *.bz2) c='bunzip2';;
            *.exe) c='cabextract';;
            *.gz)  c='gunzip';;
            *.rar) c='unrar x';;
            *.xz)  c='unxz';;
            *.zip) c='unzip';;
            *.lzh) c='lha x';;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
            continue;;
        esac
        command $c "$i"
        e=$?
    done
    return $e
}

function EC() { echo -e '\e[1;33m'code $?'\e[m'; }
trap EC ERR

ulimit -c 4096

export PYTHONSTARTUP=$HOME/.pythonrc.py

# cl() {
#     dir=$1
#     if [[ -z "$dir" ]]; then
#         dir=$HOME
#     fi
#     if [[ -d "$dir" ]]; then
#         cd "$dir"
#         ls
#     else
#         echo "bash: cl: '$dir': Directory not found"
#     fi
# }
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
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# ibus-daemon -drx
function _update_ps1() {
	export PS1="$(~/powerline-shell.py $? 2> /dev/null)"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")';
}
PROMPT_COMMAND="  _update_ps1 ; $PROMPT_COMMAND"

complete -cf sudo
complete -cf man




function peco-select-history () {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco-select-history'
bind    '"\C-xr": reverse-search-history'

if [ -x "`which ag`" ]; then
function peco-ag () {
    ag $@ | peco --query "$READLINE_LINE" | awk -F : '{print "+" $2 " " $1}' | xargs emacsclient -c
}
fi

function j(){
    if [ $# -eq 0 ] ; then
        cd $(z | tac | awk "{print \$2}" | peco)
    else
        z $*
    fi
}
screenfetch  2> /dev/null    &&  fortune 2> /dev/null
# archey3 2> /dev/null

# -s 2> /dev/null # | tr "\n" " " # | tee /tmp/trans 2> /dev/null  



# goslate.py -t ja /tmp/trans 2> /dev/null


