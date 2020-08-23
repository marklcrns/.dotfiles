#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})

source $SCRIPTDIR/../colors
source $SCRIPTDIR/../utils
source $SCRIPTDIR/install_utils.sh

# apt_add_repo test
apt_add_repo "bashtop-monitor/bashtop" 1
apt_add_repo "universe"

pip_install 3 "notebook"
