#!/bin/sh
black="/tmp/black"
now="/tmp/now"
cat blackList | sort > $black
ls -1 -a  > $now 
b=`diff $black $now | grep ">" | sed "s/[> ]//g" `
c="$PWD"
pushd $HOME
    for a in $b; do
        rm -rv $a
        echo "$c/$a"
        echo
        ln -s "$c/$a"
    done

popd


