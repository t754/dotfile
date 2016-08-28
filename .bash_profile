#
# ~/.bash_profile
#
screenfetch  2> /dev/null && fortune 2> /dev/null

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
