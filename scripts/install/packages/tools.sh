#!/bin/bash

# Tools Packages

APT_PACKAGES_TOOLS=(
  "tree"
  "xclip"
  "xdg-utils"
  "fd-find"
  "mlocate"
  "autojump"
  "k-y"
  "synaptic"
  "rclone-browser"
  "ripgrep"
  "pandoc-data"
  "pandoc"
  "texlive"
  "r-base"
  "inotify-tools"
)

APT_PACKAGES_TOOLS_CTAGS_DEPENDENCIES=(
  "gcc"
  "make"
  "pkg-config"
  "autoconf"
  "automake"
  "python3-docutils"
  "libseccomp-dev"
  "libjansson-dev"
  "libyaml-dev"
  "libxml2-dev"
)

APT_PACKAGES_TOOLS_PANDOC_DEPENDENCIES=(
  "pandoc-data"
  "pandoc"
  "texlive"
)


echolog
echolog "${UL_NC}Installing Utility Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_TOOLS[@]}"

# Git-lfs
if curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash; then
  apt_install "git-lfs"
  git lfs install
fi

# Rclone
curl_install "https://rclone.org/install.sh | sudo bash"

# Fzf
if git_clone "https://github.com/junegunn/fzf.git --depth=1" "${DOWNLOADS_DIR}/.fzf"; then
  "${DOWNLOADS_DIR}/.fzf/install"
fi

# Bat v0.15.4 (Manual)
# Ref: https://github.com/sharkdp/bat#on-ubuntu
BAT_VERSION="0.15.4"
if curl_install "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"; then
  sudo dpkg -i "bat_${BAT_VERSION}_amd64.deb"
fi

if git_clone "https://github.com/universal-ctags/ctags.git --depth=1" "${DOWNLOADS_DIR}"; then

  apt_bulk_install "${APT_PACKAGES_TOOLS_CTAGS_DEPENDENCIES[@]}"

  cd ${DOWNLOADS_DIR}/ctags
  ./autogen.sh
  ./configure
  make
  sudo make install

  cd ${DOWNLOADS_DIR}
fi

# Lazygit
if sudo add-apt-repository ppa:lazygit-team/release -y; then
  apt_install "lazygit" 1
fi

## R-Pandoc
### dependencies
if apt_install "r-base"; then

  apt_bulk_install "${APT_PACKAGES_TOOLS_PANDOC_DEPENDENCIES[@]}"

  curl -sSL https://get.haskellstack.org/ | sh
  if git_clone "https://github.com/cdupont/R-pandoc.git" "${DOWNLOADS_DIR}"; then
    cd "${DOWNLOADS_DIR}R-pandoc" && stack install

    cd "${DOWNLOADS_DIR}"
  fi
fi

# Personal pandoc configurations
git_clone "https://github.com/marklcrns/pandoc-goodies" "${HOME}/.pandoc"

# Exa
if curl_install "https://sh.rustup.rs -sSf | sh"; then
  EXA_VERSION="0.9.0"
  cd "${DOWNLOADS_DIR}"
  if wget -c "https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-${EXA_VERSION}.zip"; then
    unzip exa-linux-x86_64-${EXA_VERSION}.zip
    sudo mv exa-linux-x86_64 /usr/local/bin/exa
  fi
fi

