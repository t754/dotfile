# cask

curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
myInstall.sh
source ~/.bashrc
cat golist  | xargs -L 1 go  get
cat ghqlist | xargs -L 1 ghq get
mkdir -p ~/.tmux/plugins
ln -s ~/.ghq/github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config/systemd/user/
ln -s ${PWD}/emacs.service  ~/.config/systemd/user/emacs/
mkdir -p $HOME/.urxvt/ext
ln -s $HOME/.ghq/github.com/majutsushi/urxvt-font-size/font-size $HOME/.urxvt/ext/
mkdir -p $HOME/bin
curl https://linux.dropbox.com/packages/dropbox.py -o "$HOME/bin/dropbox"
chmod +x "$HOME/bin/dropbox"
