#
# ~/.bash_profile
#
screenfetch  2> /dev/null && fortune 2> /dev/null

export SHELL="/bin/bash"
export LANG=ja_JP.UTF-8
export TERM="screen-256color-bce"
export EDITOR="emacsclient -nw"
export PAGER="less"
# if [ -n ${DISPLAY} ] ; then
#     export DISPLAY=:0.0
# fi

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
[[ -e ~/.rbenv/completions/rbenv.bash ]] && source ~/.rbenv/completions/rbenv.bash

export PYENV_ROOT="$HOME/.pyenv"

[[ -x "$(which pyenv 2>/dev/null)" ]] && eval "$(pyenv init -)"
#Load pyenv virtualenv if the virtualenv plugin is installed.
if pyenv virtualenv-init - &> /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi
# [ -f ~/.pythonrc.py ] && export PYTHONSTARTUP=$HOME/.pythonrc.py

export GOPATH="$HOME/.go"

export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH="$HOME/bin:$PYENV_ROOT/bin:$HOME/.rbenv/bin:$PATH:/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.cabal/bin/:$HOME/node_modules/.bin/:$GOPATH/bin:$HOME/.rbenv/bin:/usr/bin/vendor_perl"
if which ruby >/dev/null && which gem >/dev/null; then
  export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
fi

export PATH=$(echo $PATH":" | tr ":" "\0" |  xargs -0 -I% sh -c 'test -d "%" && echo -n "%:"' | sed 's/:$//')

export LD_LIBRARY_PATH="/lib:/lib64:/usr/lib64:/usr/lib32:/usr/lib:/usr/local/lib"
export LDFLAGS=""
# SCREEN buffer
export SCREENEXCHANGE="/tmp/screen-exchange"
export IGNOREEOF=1
stty stop undef
export MANPATH=/usr/share/man/ja:
export _Z_CMD=z

export BASH_ENV="$HOME/.bashrc"
[[ -f ~/.bashrc ]] && . ~/.bashrc


# if [[ -x "$(which keychain)" && $- = *i* && ${_MY_EMACS} != "T" ]] ; then
#     echo $(date) "profile::  " $- >> ~/FFFF
#     printenv  > /tmp/eee$(date +%s)
#     declare -A keychainHostHash=(
#         ["localhost.localdomain"]="ssh id_rsa.bit2 id_rsa.zt2"
#         ["utrtamako"]="ssh id_rsa.bit"
#     )
#     if [ ${keychainHostHash[$(hostname)]+_} ]; then
#         eval $(keychain --eval --agents ${keychainHostHash[$(hostname)]})
#     fi
# fi
