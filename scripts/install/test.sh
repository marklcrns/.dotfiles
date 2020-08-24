#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="$(realpath "${SCRIPTDIR}/../..")"
DOWNLOADS_DIR="${HOME}/Downloads"

source "${SCRIPTDIR}/../colors"
source "${SCRIPTDIR}/../utils"
source "${SCRIPTDIR}/install_utils.sh"

