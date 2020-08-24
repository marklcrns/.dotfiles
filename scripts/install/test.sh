#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="$(realpath "${SCRIPTDIR}/../..")"
DOWNLOADS_DIR="${HOME}/Downloads"

source "${SCRIPTDIR}/../colors"
source "${SCRIPTDIR}/../utils"
source "${SCRIPTDIR}/install_utils.sh"

# Distribute dotfiles into $HOME
${DOTFILES_ROOT}/bin/tools/dotfiles/dotdist -V -r "${DOTFILES_ROOT}/.dotfilesrc" "${DOTFILES_ROOT}" "${HOME}"
