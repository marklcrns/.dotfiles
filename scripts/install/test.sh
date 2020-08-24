#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="${SCRIPTDIR}/../.."
DOWNLOADS_DIR="${HOME}/Downloads"

source "${SCRIPTDIR}/../colors"
source "${SCRIPTDIR}/../utils"
source "${SCRIPTDIR}/install_utils.sh"

# Distribute dotfiles into $HOME
source ${DOTFILES_ROOT}/.dotfilesrc
${DOTFILES_ROOT}/bin/tools/dotfiles/dotdist -v "${DOTFILES_ROOT}" "${HOME}"
