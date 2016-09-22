#!/bin/bash
if [[ $# -le 0 ]] ; then
    echo "arg linux distros \
(ex ubuntu,fedora,arch)"
    exit 1
fi
source .bashrc

set -eu
{
    go get github.com/FooSoft/homemaker
    homemaker  -verbose  homeLink.toml .
    homemaker  -task ghq -verbose  homeLink.toml .
    homemaker  -variant $1 -task dropbox -verbose  homeLink.toml .
}
set +eu

# init powerline-shell
source ~/.bashrc
ghq look powerline-shell
./install.py
