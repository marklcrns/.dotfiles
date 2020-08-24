#!/bin/bash

APT_PACKAGES_SHELL=(
  "zsh"
)

echolog
echolog "${UL_NC}Installing Shell Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_SHELL[@]}"

# Oh-my-zsh, plugins and themes
if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
  [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins" ]] && mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
  git_clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git_clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  git_clone "https://github.com/romkatv/powerlevel10k.git" "${HOME}/.oh-my-zsh/themes/powerlevel10k"
fi

