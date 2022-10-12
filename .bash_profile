# source ~/.profile
if [[ -f "${HOME}/.profile" ]]; then
  . "${HOME}/.profile"
fi

# source ~/.bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
  . "${HOME}/.bashrc"
fi

[[ -e "${HOME}/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
