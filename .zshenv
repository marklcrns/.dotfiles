if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  . "${VIRTUAL_ENV}/bin/activate"
fi
[[ -e "${HOME}/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
