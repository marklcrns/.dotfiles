if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi
. "$HOME/.cargo/env"
if [ -e /home/markl/.nix-profile/etc/profile.d/nix.sh ]; then . /home/markl/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
