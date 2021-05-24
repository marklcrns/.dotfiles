# source ~/.profile
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

# source ~/.bashrc
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.bashrc"
fi

if [ -e /home/markl/.nix-profile/etc/profile.d/nix.sh ]; then . /home/markl/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
