# ~/.bashrc
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

[ -r "$HOME/.aliasrc" ] && . $HOME/.aliasrc
# set -x
export TERM="xterm-256color"
export COLORTERM="mlterm"
export EDITOR="emacsclient -nw"
export ALTERNATE_EDITOR=""
export PAGER="less"
export LESS=' -R -X -I'
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
export VISUAL="emacsclient"
export BROWSER="firefox"
export TZ="Asia/Tokyo"
export LC_MESSAGES="C"
# 重複服歴を無視
# export HISTCONTROL=ignoredups
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend


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
export PATH="$HOME/bin:$HOME/.rbenv/shims:$PATH:/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.cabal/bin/:$HOME/node_modules/.bin/:$GOPATH/bin:$HOME/.rbenv/bin:/usr/bin/vendor_perl"
export PATH=$(echo $PATH":" | tr ":" "\0" |  xargs -0 -I% sh -c 'test -d "%" && echo -n "%:"' | sed 's/:$//')
export LD_LIBRARY_PATH="/lib:/lib64:/usr/lib64:/usr/lib32:/usr/lib:/usr/local/lib"
export LDFLAGS=""
# SCREEN buffer
export SCREENEXCHANGE="/tmp/screen-exchange"
export IGNOREEOF=1
stty stop undef
export MANPATH=/usr/share/man/ja:
export _Z_CMD=z
[ -r ~/.ghq/github.com/rupa/z/z.sh ] && source ~/.ghq/github.com/rupa/z/z.sh
[ -r $HOME/.tmuxinator/tmuxinator.bash ] && source $HOME/.tmuxinator/tmuxinator.bash



ulimit -c 4096
[ -f ~/.pythonrc.py ] && export PYTHONSTARTUP=$HOME/.pythonrc.py



# POWERLINE OLD
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export POWERSHELL_MODE="flat"
else
    export POWERSHELL_MODE="patched"
fi
function _update_ps1() {
    export PS1="$(python2 ${HOME}/dotfile/powerline-shell.py --mode ${POWERSHELL_MODE} --shell bash $? 2> /dev/null)"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")';
}
PROMPT_COMMAND="  _update_ps1 ; $PROMPT_COMMAND"


complete -cf sudo
complete -cf man





if [ "x${WINDOWID}" != "x" ] ; then
    if [ -x "`which keychain`" ]; then
        if [ $(hostname) = "localhost.localdomain" ]; then
            eval $(keychain --eval --nogui -Q -q --agents ssh id_rsa.bit2 id_rsa.zt2)
        else
            eval $(keychain --eval --nogui -Q -q --agents ssh id_rsa.bit)
        fi
    fi
fi

function EC() { echo -e '\e[1;33m'code $?'\e[m'; }
trap EC ERR

# source ~/.ghq/github.com/arialdomartini/oh-my-git/prompt.sh
