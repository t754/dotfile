# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

ulimit -c 4096


export SHELL="/bin/bash"
export LANG=ja_JP.UTF-8
export EDITOR="emacsclient -nw"
# if [ -n ${DISPLAY} ] ; then
#     export DISPLAY=:0.0
# fi

# set -x
export TERM="xterm-256color"
export COLORTERM="mlterm"
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode
export ALTERNATE_EDITOR=""
export PAGER="less"
export LESS='-g -i -M -R -S -W -z-4 -x4'
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
export BROWSER="firefox"
export TZ="Asia/Tokyo"
export LC_MESSAGES="C"
# 重複服歴を無視
# export HISTCONTROL=ignoredups
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
builtin set -o histexpand;


# ${PROMPT_COMMAND:$PROMPT_COMMAND$'\n'}
export PROMPT_COMMAND=" history -a; history -c; history -r;"

export HISTIGNORE="fg*:bg*:history*:rm*"
export HISTSIZE=10000 # C-r C-s　で履歴を検索できるらしい

# export COLORTERM="mlterm"
if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi


if type luarocks >/dev/null 2>&1; then
    eval "$(luarocks path --bin)"
fi
# [ -f ~/.pythonrc.py ] && export PYTHONSTARTUP=$HOME/.pythonrc.py
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH="$HOME/.go"
export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
export PATH="$PYENV_ROOT/bin:$HOME/bin:$HOME/.local/bin:$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH:/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.cabal/bin/:$HOME/node_modules/.bin/:/usr/local/go/bin:$GOPATH/bin:$GOBIN:$HOME/.rbenv/bin:/usr/bin/vendor_perl"
export PATH="$PATH:$HOME/go/bin:$HOME/.cargo/bin"
if which ruby &>/dev/null && which gem &>/dev/null; then
  export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -r "$HOME/google-cloud-sdk/path.bash.inc" ]]  && source "$HOME/google-cloud-sdk/path.bash.inc"
[[ -r "$HOME/google-cloud-sdk/completion.bash.inc" ]] && source "$HOME/google-cloud-sdk/completion.bash.inc"
[[ -r "$HOME/lib/azure-cli/az.completion" ]] && source "$HOME/lib/azure-cli/az.completion"
[[ -r "$HOME/.bashrc.local.bash" ]] && source "$HOME/.bashrc.local.bash"
[[ -r "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"

export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S "
if which npm &> /dev/null ; then
  export PATH="$PATH:$(npm root)/.bin"
fi

export PATH=$(echo $PATH | tr ':' '\n' | xargs -L1 -I@@ sh -c '[ -d "@@" ] && echo "@@"' | awk '!/^[:space:]*$/ && !a[$0]++' | tr '\n' ':')
export LD_LIBRARY_PATH="/lib:/lib64:/usr/lib64:/usr/lib32:/usr/lib:/usr/local/lib"
export LDFLAGS=""
# SCREEN buffer
export SCREENEXCHANGE="/tmp/screen-exchange"
export IGNOREEOF=1
stty stop undef
export MANPATH=/usr/share/man/ja:
export _Z_CMD=z
if [[ -x "$(which rustc 2>/dev/null)" ]] ; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export POWERSHELL_MODE="flat"
else
    export POWERSHELL_MODE="patched"
fi

export powerlineShellPath="$(ghq list -p | grep 'milkbikis/powerline-shell')"
export powerlineArgopt="--colorize-hostname --cwd-mode=fancy --cwd-max-depth=4 --mode ${POWERSHELL_MODE} --shell bash"

railsComp="$(ghq list -p | grep 'jweslley/rails_completion')"
[[ -d $railsComp  ]] && source $railsComp"/rails.bash"

[[ -x "$(which fasd 2>/dev/null)" ]] && eval "$(fasd --init auto)"
[[ -x "$(which kubectl 2>/dev/null)" ]] && source <(kubectl completion bash)
[[ -x "$(which helm 2>/dev/null)" ]] && source <(helm completion bash)
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[ -r "$HOME/.aliasrc" ] && . $HOME/.aliasrc
[ -r ~/.ghq/github.com/rupa/z/z.sh ] && source ~/.ghq/github.com/rupa/z/z.sh
[ -r $HOME/.cargo/env ] && source $HOME/.cargo/env
if [ -x "${powerlineShellPath}/powerline-shell.py" ] ; then
    function _update_ps1() {
        export PS1="$(${powerlineShellPath}/powerline-shell.py ${powerlineArgopt} $? 2> /dev/null) \n"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")';
    }
    export PROMPT_COMMAND="  _update_ps1 ; $PROMPT_COMMAND"
fi

complete -cf sudo
complete -cf man

function EC() { echo -e '\e[1;33m'code $?'\e[m'; }
trap EC ERR

# source ~/.ghq/github.com/arialdomartini/oh-my-git/prompt.sh

peco() {
    fzf +s
}


[[ -x "$(which pyenv 2>/dev/null)" ]] && eval "$(pyenv init -)"

#Load pyenv virtualenv if the virtualenv plugin is installed.
if pyenv virtualenv-init - &> /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi


[ -f $HOME/.complete_bundle_exec.sh ] && source $HOME/.complete_bundle_exec.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f $HOME/.bashrc.local ] && source $HOME/.bashrc.local





# Path to the bash it configuration
export BASH_IT="/home/zztama/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
# export BASH_IT_THEME='bobby'
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
# export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh


# added by travis gem
[ -f /home/t-nagoshi/.travis/travis.sh ] && source /home/t-nagoshi/.travis/travis.sh
