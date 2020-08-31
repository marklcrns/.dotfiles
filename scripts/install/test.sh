#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="$(realpath "${SCRIPTDIR}/../..")"
DOWNLOADS_DIR="${HOME}/Downloads"

############################################## EXTERNAL DEPENDENCIES SCRIPTS ###

# Ansi color code variables
if [[ -e "${SCRIPTDIR}/../colors" ]]; then
  source "${SCRIPTDIR}/../colors"
else
  echo "${SCRIPTPATH} WARNING: Failed to source '../colors' dependency"
  echo
fi
# Utility functions
if [[ -e "${SCRIPTDIR}/../utils" ]]; then
  source "${SCRIPTDIR}/../utils"
else
  echo "${SCRIPTPATH} ERROR: Failed to source '../utils' dependency"
  exit 1
fi
# Install utility functions
if [[ -e "${SCRIPTDIR}/install_utils.sh" ]]; then
  source "${SCRIPTDIR}/install_utils.sh"
else
  echo "${SCRIPTPATH} ERROR: Failed to source './install_utils.sh' dependency"
  exit 1
fi

##################################################### SCRIPT MAIN EXECUTIONS ###


# NVM/NodeJS
if curl_install "https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"; then
  # source bashrc or zshrc
  if [[ -n ${BASH_VERSION} ]]; then
    source ~/.bashrc
  elif [[ -n ${ZSH_VERSION} ]]; then
    source ~/.zshrc
  fi
  # Install latest nvm and set to default
  export LATEST_NPM="$(nvm ls-remote | tail -1 | sed 's/^.*\(v[0-9\.]\)/\1/')"
  ## install latest npm
  nvm install ${LATEST_NPM}
  nvm use ${LATEST_NPM}
  nvm alias default ${LATEST_NPM}
fi


#################################################################### WRAP UP ###

total_count=0
successful_count=0
skipped_count=0
failed_count=0

echolog
echolog "${UL_NC}Successful Installations${NC}"
echolog
while IFS= read -r package; do
  if [[ -n ${package} ]]; then
    ok "${package}"
    total_count=$(expr ${total_count} + 1)
    successful_count=$(expr ${successful_count} + 1)
  fi
done < <(echo -e "${successful_packages}") # Process substitution for outside variables

echolog
echolog "${UL_NC}Skipped Installations${NC}"
echolog
while IFS= read -r package; do
  if [[ -n ${package} ]]; then
    warning "${package}"
    total_count=$(expr ${total_count} + 1)
    skipped_count=$(expr ${skipped_count} + 1)
  fi
done < <(echo -e "${skipped_packages}") # Process substitution for outside variables

echolog
echolog "${UL_NC}Failed Installations${NC}"
echolog
while IFS= read -r package; do
  if [[ -n ${package} ]]; then
    error "${package}"
    total_count=$(expr ${total_count} + 1)
    failed_count=$(expr ${failed_count} + 1)
  fi
done < <(echo -e "${failed_packages}") # Process substitution for outside variables

echolog
echolog "Successful installations:\t${successful_count}"
echolog "Skipped installations:\t\t${skipped_count}"
echolog "failed installations:\t\t${failed_count}"
echolog "${BO_NC}Total installations:\t\t${total_count}"

finish 'TEST INSTALLATION COMPLETE!'
