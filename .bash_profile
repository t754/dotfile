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
export BASH_ENV="$HOME/.bashrc"
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -x "`which keychain`" ]; then
    if [ $(hostname) = "localhost.localdomain" ]; then
        eval $(keychain --eval --agents ssh id_rsa.bit2 id_rsa.zt2)
    else
        eval $(keychain --eval --agents ssh id_rsa.bit)
    fi
fi
