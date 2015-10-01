#!/bin/sh
function _myCheck(){
    type $1 || exit
}

_myCheck go
_myCheck curl
type ghq || go get github.com/motemen/ghq
_myCheck ghq

curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

# black="/tmp/black"
# now="/tmp/now"
# cat blackList | sort > $black
# ls -1 -a  > $now
# b=`diff $black $no|w | grep ">" | sed "s/[> ]//g" `

b=$(comm -13 <(sort blackList) <(ls -a -1 | sort))
c="$PWD"
pushd ${HOME}
    for a in $b; do
        rm -rv $a
        echo "$c/$a"
        echo
        ln -s "$c/$a"
    done
popd

source ~/.bashrc
cat golist  | xargs -L 1 go  get
cat ghqlist | xargs -L 1 ghq get

mkdir -p ~/.tmux/plugins
ln -s ~/.ghq/github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.config/systemd/user/
ln -s ${PWD}/emacs.service  ~/.config/systemd/user/emacs/

mkdir -p ${HOME}/.urxvt/ext
ln -s ${HOME}/.ghq/github.com/majutsushi/urxvt-font-size/font-size ${HOME}/.urxvt/ext/

mkdir -p ${HOME}/bin
curl https://linux.dropbox.com/packages/dropbox.py -o "${HOME}/bin/dropbox"
chmod +x "${HOME}/bin/dropbox"

mkdir -p ${HOME}/.config/fontconfig/
ln -s ${PWD}/conf.d ${HOME}/.config/fontconfig
