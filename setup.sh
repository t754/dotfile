# cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
myInstall.sh
cat golist  | xargs -L 1 go  get
cat ghqlist | xargs -L 1 ghq get
mkdir -p ~/.tmux/plugins
ln -s ~/.ghq/github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config/systemd/user/
ln -s ${PWD}/emacs.service  ~/.config/systemd/user/emacs/
