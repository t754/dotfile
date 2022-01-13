#!/bin/bash -exv
# source .bashrc
ROOT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BACKUPDIR="${HOME}/backup_setup_sh"
mkdir -p $BACKUPDIR

declare -a symlink_array=(
    ".bashrc"
    ".Xresources"
    ".aliasrc"
    ".bash_profile"
    ".bashrc"
    ".emacs.d"
    ".latexmkrc"
    ".gitignore"
    ".gitconfig"
    ".hgrc"
    ".inputrc"
    ".tmux.conf"
    ".Xmodmap"
    ".xmonad"
    ".zshrc"
    ".config/awesome"
    ".config/fontconfig/conf.d"
    ".config/systemd/user/emacs.service"
    ".config/systemd/user/xkeysnail.service"
    ".config/systemd/user/ssh-agent.service"
    ".config/dunst/dunstrc"
    ".config/alacritty/alacritty.yml"
)

# key = src
# value = dst
declare -A symlink_hash=(
    # [""]=".config/"
)

my_symlink(){
    src="$1"
    dst="$2"
    dstdir=$(dirname "$dst")

    if [[ ! -d $dstdir ]] ; then
        mkdir -p "$dstdir"
    fi
    if [[ -f $dst ]] ; then
        mv --backup=t "$dst" "${BACKUPDIR}/"
    elif [[ -h $dst ]] ; then
	    unlink $dst
    fi
    ln --backup=numbered -vs "$src" "$dst"
}

deploy_symlink_array(){
    for f in "${symlink_array[@]}"
    do
        my_symlink "${ROOT_DIR}/${f}" "${HOME}/${f}"
    done
}

deploy_symlink_hash(){
    for k in "${!symlink_hash[@]}"
    do
        my_symlink "${ROOT_DIR}/${k}" "${HOME}/${symlink_hash[${k}]}"
    done
}

setup_go(){
    if [[ ! -x "$(which go)" ]]; then
        return -1
    fi
    if [[ ! -x "$(which ghq)" ]]; then
        go get github.com/x-motemen/ghq
    fi
    ghq get https://github.com/clvv/fasd
    my_symlink "$(ghq root)"/"$(ghq list clvv/fasd)"/fasd $HOME/bin/fasd

    ghq get https://github.com/tmux-plugins/tpm
    my_symlink "$(ghq root)"/"$(ghq list tmux-plugins/tpm)" $HOME/.tmux/plugins/tpm

    ghq get https://github.com/tmux-plugins/tpm

    ghq get github.com/Bash-it/bash-it
    my_symlink "$(ghq root)"/"$(ghq list Bash-it/bash-it)" $HOME/.bash_it
}


# main
deploy_symlink_array
deploy_symlink_hash
setup_go
