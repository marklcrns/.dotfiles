#!/bin/bash

# Misc Packages

APT_PACKAGES_MISC=(
  "colordiff"
  "cmatrix"
  "cowsay"
  "xcowsay"
  "figlet"
  "lolcat"
  "fortune"
  "sl"
  "sysbench"
  "stress"
  "inotify-tools"
  "taskwarrior"
  "timewarrior"
  "bat"
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
echolog "${UL_NC}Installing Misc Packages${NC}"
echolog

# Bashtop
apt_add_repo "bashtop-monitor/bashtop" 1
apt_install "bashtop" 1

# Glances
pip_install 3 "glances"

apt_bulk_install "${APT_PACKAGES_MISC[@]}"

# Battery saving tool
apt_install tlp && sudo tlp start

# Tldr
[[ ! -d "${HOME}/bin" ]] && mkdir -p "${HOME}/bin"
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr && \
  chmod +x ~/bin/tldr

# Universal-ctags
if git_clone "--depth=1 https://github.com/universal-ctags/ctags.git" "${DOWNLOADS_DIR}/ctags"; then
  apt_bulk_install "${APT_PACKAGES_TOOLS_CTAGS_DEPENDENCIES[@]}"

  cd "${DOWNLOADS_DIR}/ctags"
  ./autogen.sh
  ./configure
  make
  sudo make install

  cd ${DOWNLOADS_DIR}
fi

# Lazygit
if apt_add_repo "lazygit-team/release" 1; then
  apt_install "lazygit" 1
fi

# R-Pandoc
if command -v R; then
  if curl_install "https://get.haskellstack.org/ | sh"; then
    apt_bulk_install "${APT_PACKAGES_TOOLS_PANDOC_DEPENDENCIES[@]}"
    if git_clone "https://github.com/cdupont/R-pandoc.git" "${DOWNLOADS_DIR}/R-pandoc"; then
      cd "${DOWNLOADS_DIR}R-pandoc" && stack install
    fi
  fi
fi

# Exa
if command -v cargo; then
  EXA_VERSION="0.9.0"
  cd "${DOWNLOADS_DIR}"
  if wget_install "https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/exa-linux-x86_64-${EXA_VERSION}.zip"; then
    unzip exa-linux-x86_64-${EXA_VERSION}.zip
    sudo mv exa-linux-x86_64 /usr/local/bin/exa
  fi
fi

