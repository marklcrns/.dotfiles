#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOWNLOADS_DIR="${HOME}/Downloads"

source "${SCRIPTDIR}/../colors"
source "${SCRIPTDIR}/../utils"
source "${SCRIPTDIR}/install_utils.sh"

if git_clone "--depth=1 https://github.com/junegunn/fzf.git" "${DOWNLOADS_DIR}/.fzf"; then
  echo "OK FZF"
fi

if git_clone "--depth=1 https://github.com/universal-ctags/ctags.git" "${DOWNLOADS_DIR}/ctags"; then
  echo "OK CTAGS"
fi

if curl_install "https://sh.rustup.rs | sh"; then
  EXA_VERSION="0.9.0"
  cd "${DOWNLOADS_DIR}"
  if wget_install "https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-${EXA_VERSION}.zip"; then
    unzip exa-linux-x86_64-${EXA_VERSION}.zip
    sudo mv exa-linux-x86_64 /usr/local/bin/exa
  fi
fi
