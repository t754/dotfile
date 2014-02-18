# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

alias ls='ls -x -v --color=auto'
alias ll='ls -la'
alias la='ls -a'
alias df='df -h'
alias starte='emacs --daemon'
alias e="emacsclient -c"
alias enox="emacsclient"
alias E='SUDO_EDITOR="emacsclient -c" sudo -e '
alias Enox='SUDO_EDITOR="emacsclient " sudo -e '
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias server_name='ssh -v -l USERNAME IP ADDRESS'
alias du="du -h -c"
alias df="df -h -T --total"
alias grep="grep -i -n --color"
alias bee='aplay ~/beep.wav' 
alias pgg='ps -Af | grep'
alias xsels='xsel -ib < /tmp/screen-exchange'

# coredump した場所
alias core="sudo systemd-coredumpctl list | tail"
alias coreout='sudo systemd-coredumpctl dump -o core'
# 重複服歴を無視
export HISTCONTROL=ignoredups
export HISTIGNORE="fg*:bg*:history*:rm*"

export HISTSIZE=10000 # C-r C-s　で履歴を検索できるらしい
export latexs='latexmk -e =q/platex -interaction nonstopmode %S/ -e =q/pbibtex %B/ -e =q/mendex -o %D %S/ -e =q/dvipdfmx -o %D %S/ -norc -gg -pdfdvi'

export LANG=ja_JP.UTF-8
export EDITOR="emacsclient -nw"
export PAGER=less


export PATH="$PATH:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.cabal/bin/:$HOME/.gem/ruby/2.0.0/bin/:$HOME/.gem/ruby/2.1.0/bin/"
export LD_LIBRARY_PATH="/lib:/lib64:/usr/lib64:/usr/lib32:/usr/lib:/usr/local/lib"
export LDFLAGS=""

# SCREEN buffer
export SCREENEXCHANGE="/tmp/screen-exchange"

if [ -n ${DISPLAY} ] ; then
    export DISPLAY=:0.0
fi

function Cl(){
	echo "$1" | xsel --input --clipboard
}

function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


function uuuu {
	/usr/bin/sensors 2> /dev/null | awk '"Core" == $1 { i += int($3); n++} END{ printf( "%d",i/n) }'
}

function mmmm {
	free | awk '/^\-\/\+/{ printf("\033[1;42;37m%05.2f\033[0m ",$3/($3+$4)*100) } /^Swap/{printf("\033[1;44;37m%05.2f\033[0m",$3/$2*100) }'
}


function proml {
	export PS1="\e[41m \e[0m\e[1;32m\@\e[0m \e[1;105;93m\w\e[0m \e[41m \e[0m\j\e[0m
\e[41m \e[0m \e[1;47;34m\u\e[0m\e[1;35m\$(parse_git_branch) \e[0m\
\e[0m\$(uuuu)℃ \$(mmmm)\e[41m \e[0m
\$>"
}
proml


extract() {
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
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz))))) c='bsdtar xvf';;
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

EC() { echo -e '\e[1;33m'code $?'\e[m\n'; }
trap EC ERR

ulimit -c 4096



# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# ibus-daemon -drx

