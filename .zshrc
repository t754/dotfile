 # [[ -s /etc/profile.d/autojump.sh ]] && . /etc/profile.d/autojump.sh
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
# [[ -s $HOME/.autojump/etc/profile.d/autojump.zsh ]] && source $HOME/.autojump/etc/profile.d/autojump.zsh


# autoload -U  promptinit && promptinit
fpath=($HOME/zsh-completions/src $fpath)
autoload -U compinit && compinit -u
# # 問題解決？
# export PROMPT_COMMAND="history -a"
# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
# This will set the default prompt to the walters theme


# setopt completealiases
###### command not found
[ -r /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

###### alias  bashと一緒の
[ -r $HOME/.aliasrc ] && . $HOME/.aliasrc
export GTK_IM_MODULE="ibus"
export XMODIFIERS="@im=ibus"
export XMODIFIER="@im=ibus"
export QT_IM_MODULE="ibus"
export DefaultIMModule=ibus
export ALTERNATE_EDITOR=emacs EDITOR=emacsclient VISUAL=emacsclient
export TERM="xterm-256color"
export COLORTERM="mlterm"
export EDITOR="emacsclient -nw"
export PAGER="less"
##ls 色の付け方？
export LSCOLORS=Exfxcxdxbxegedabagacad
export GOPATH="$HOME/go"

export PATH="$HOME/.cask/bin:$PATH:$HOME/adt-bundle-linux/sdk/platform-tools:$GOPATH/bin"
export PATH="$HOME/H8H/bin:$PATH"
export PYTHONSTARTUP=$HOME/.pythonrc.py

#####Kemmap?
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
# emacs likes
bindkey -e
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


##### ncurses 用 バインド
ncmpcppShow() { BUFFER="ncmpcpp"; zle accept-line; }
zle -N ncmpcppShow
bindkey '^[\' ncmpcppShow


#### 履歴
# 途中結果参照コマンド履歴
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward
### History ###
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=10000            # メモリに保存されるヒストリの件数
SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
# setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
# setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存す
setopt EXTENDED_HISTORY


#### 補完の設定
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:default' menu select=1


# # gitプロンプト用
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' formats '(%s)-[%b]'
# zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
# precmd () {
#     psvar=()
#     LANG=en_US.UTF-8 vcs_info
#     [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
# }
# RPROMPT="%1(v|%F{green}%1v%f|)"

##### root時に下線をつける
if [ ${UID} -eq 0 ]; then
	tmp_prompt="%B%U${tmp_prompt}%u%b"
	tmp_prompt2="%B%U${tmp_prompt2}%u%b"
	tmp_rprompt="%B%U${tmp_rprompt}%u%b"
	tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;



# 展開一式
function extract() {
	case $1 in
		*.tar.gz|*.tgz) tar xzvf $1;;
		*.tar.xz) tar Jxvf $1;;
		*.zip) unzip $1;;
		*.lzh) lha e $1;;
		*.tar.bz2|*.tbz) tar xjvf $1;;
		*.tar.Z) tar zxvf $1;;
		*.gz) gzip -dc $1;;
		*.bz2) bzip2 -dc $1;;
		*.Z) uncompress $1;;
		*.tar) tar xvf $1;;
		*.arj) unarj $1;;
	esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

# コンパイル面倒くさい用 
function runcpp () { g++ $1 && shift && ./a.out $@ }




######powerline
function powerline_precmd() {
    export PS1="$(~/powerline-shell.py $? --shell zsh 2> /dev/null)"
}

function install_powerline_precmd() {
    for s in "${precmd_functions[@]}"; do
        if [ "$s" = "powerline_precmd" ]; then
			return
        fi
    done
    precmd_functions+=(powerline_precmd)
}

install_powerline_precmd


# autojump
export AUTOJUMP_IGNORE_CASE=1
setopt auto_cd                  # ディレクトリ名と一致した場合 cd 
setopt autopushd
setopt pushd_ignore_dups        # 同じディレクトリは追加しない



# [ -s /etc/profile.d/autojump.zsh ] && source /etc/profile.d/autojump.zsh 
# (set -x ; source /etc/profile.d/autojump.zsh)


# if [ -z "$STY" ] ; then
#     screen -Rd "work"
# else
#     archey3
#     fortune -s | tee /tmp/trans;echo;goslate.py -t ja /tmp/trans
# fi
# $HOME/screenfetch 2> /dev/null    


