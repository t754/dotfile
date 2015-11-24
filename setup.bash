#!/bin/bash
function _myCheck(){
    type $1 || exit
}

_myCheck go
_myCheck curl
type ghq || go get github.com/motemen/ghq
_myCheck ghq

# curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python


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

mkdir -p ${HOME}/.urxvt/ext
ln -s ${HOME}/.ghq/github.com/majutsushi/urxvt-font-size/font-size ${HOME}/.urxvt/ext/

mkdir -p ${HOME}/bin
curl https://linux.dropbox.com/packages/dropbox.py -o "${HOME}/bin/dropbox"
chmod +x "${HOME}/bin/dropbox"




function _mkdir_ln(){
    if [ $#  -ne 2 ] ; then
        echo "usage :: _mkdir_ln src dst"
        return 1
    fi

    mkdir -p $(dirname $2)
    if [ -L $2 ] ; then
        rm -v $2
    fi
    ln -vs $1 $2
    return 0
}
export -f _mkdir_ln

paste -d " " <(find $(pwd) -name "@*"| awk '{print "'\''" $0 "'\''"}') \
             <( find . -name "@*" |  sed -e s@"./"@@ -e s/"@"// -e s."#"."/".g  -e 's/~/$/g' ) \
  | xargs -L 1 -I@ bash -c "_mkdir_ln @"
find ~ -maxdepth 1 -type l -regex '.*/@.*' | xargs rm -v
