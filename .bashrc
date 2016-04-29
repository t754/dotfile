# ~/.bashrc
# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[ -r "$HOME/.aliasrc" ] && . $HOME/.aliasrc
[ -r ~/.ghq/github.com/rupa/z/z.sh ] && source ~/.ghq/github.com/rupa/z/z.sh
[ -r $HOME/.tmuxinator/tmuxinator.bash ] && source $HOME/.tmuxinator/tmuxinator.bash
[ -r $HOME/.bashrc.local.bash ] && source $HOME/.bashrc.local.bash

ulimit -c 4096

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export POWERSHELL_MODE="flat"
else
    export POWERSHELL_MODE="patched"
fi

export powerlineShellPath="$(ghq list -p | grep 'milkbikis/powerline-shell')"
export powerlineArgopt="--colorize-hostname --cwd-mode=fancy --cwd-max-depth=4 --mode ${POWERSHELL_MODE} --shell bash"
function _update_ps1() {
    export PS1="$(${powerlineShellPath}/powerline-shell.py ${powerlineArgopt} $? 2> /dev/null)"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")';
}
export PROMPT_COMMAND="  _update_ps1 ; $PROMPT_COMMAND"

complete -cf sudo
complete -cf man

function EC() { echo -e '\e[1;33m'code $?'\e[m'; }
trap EC ERR

# source ~/.ghq/github.com/arialdomartini/oh-my-git/prompt.sh
