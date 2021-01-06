#!/bin/bash

# Installer script for Android
#
# Store .dotfiles repo in ~/Projects/.dotfiles
#





################################################## CONSTANT GLOBAL VARIABLES ###

LOG_FILE_DIR="${HOME}/log"
LOG_FILE="$(date +"%Y-%m-%dT%H:%M:%S")_$(basename -- $0).log"

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="$(realpath "${SCRIPTDIR}/../..")"

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

############################################################### FLAG OPTIONS ###

# TODO: Finish implement debug, quiet and verbose flags

# Display help
usage() {
  cat << EOF
USAGE:

Command description.

  command [ -DsvVy ]

OPTIONS:

  -D  debug mode (redirect output in log file)
  -q  quiet output
  -q  quiet output except errors
  -v  verbose output
  -V  very verbose output
  -y  skip confirmation
  -h  help

EOF
}

# Set flag options
while getopts "DqQvVyh" opt; do
  case "$opt" in
    D) [[ -n "$DEBUG"           ]] && unset DEBUG                      || DEBUG=true;;
    q) [[ -n "$IS_QUIET"        ]] && unset IS_QUIET                   || IS_QUIET=true;;
    Q) [[ -n "$IS_ERROR_QUIET"  ]] && unset IS_ERROR_QUIET             || IS_QUIET=true; IS_ERROR_QUIET=true;;
    v) [[ -n "$IS_VERBOSE"      ]] && unset IS_VERBOSE                 || IS_VERBOSE=true;;
    V) [[ -n "$IS_VERY_VERBOSE" ]] && unset IS_VERBOSE IS_VERY_VERBOSE || IS_VERBOSE=true; IS_VERY_VERBOSE=true;;
    y) [[ -n "$SKIP_CONFIRM"    ]] && unset SKIP_CONFIRM               || SKIP_CONFIRM=true;;
    h) usage && exit 0;;
    *) usage && echo -e "${SCRIPTPATH}:\n${RED}ERROR: Invalid flag.${NC}"
      exit 1
  esac
done 2>/dev/null
shift "$((OPTIND-1))"

####################################################### PRE-EXECUTION SET UP ###

# Strip trailing '/' in DIR path variables
LOG_FILE_DIR=$(echo ${LOG_FILE_DIR} | sed 's,/*$,,')

# Log stdout and stderr to $LOG_FILE in $LOG_FILE_DIR
if [[ -n "${DEBUG}" ]]; then
  # Append LOG_FILE
  LOG_FILE_PATH="${LOG_FILE_DIR}/${LOG_FILE}"
  # Create log directory if not existing
  if [[ ! -d "${LOG_FILE_DIR}" ]]; then
    mkdir -p "${LOG_FILE_DIR}"
  fi
  # Initialize log file
  echo -e "${SCRIPTPATH} log outputs\n" > ${LOG_FILE_PATH}
fi

################################################## SCRIPT ARGUMENTS HANDLING ###

##################################################### SCRIPT MAIN EXECUTIONS ###

# Confirmation
if [[ -z "${SKIP_CONFIRM}" ]]; then
  log "Do you wish to continue? (Y/y): \n" 1
  ${SCRIPTDIR}/../confirm "Do you wish to continue? (Y/y): "
  if [[ "${?}" -eq 1 ]]; then
    abort "${SCRIPTPATH}: Aborted."
  elif [[ "${?}" -eq 2 ]]; then
    error "${SCRIPTPATH}: Unsupported shell"
  fi
fi

DOWNLOADS_DIR="${HOME}/Downloads"
PACKAGES="${SCRIPTDIR}/packages"

[[ ! -d "${HOME}/Projects" ]] && mkdir -p "${HOME}/Projects"
[[ ! -d "${HOME}/Downloads" ]] && mkdir -p "${DOWNLOADS_DIR}"

cd ${DOWNLOADS_DIR}

successful_packages=""
failed_packages=""
skipped_packages=""

# Apt update and upgrade
if ! (pkg upgrade -y); then
  error "Pkg update and upgrade failed" 1
fi


############### Essentials ################

PKG_ESSENTIALS_PACKAGES=(
  "build-essential"
  "git"
  "git-lfs"
  "man"
  "zip"
  "unzip"
  "mlocate"
  "htop"
  "neofetch"
  "python"
  "nodejs"
  "nvim"
  "tmux"
  "fzf"
  "ripgrep"
  "fd"
)

PKG_MISC_PACKAGES=(
  "bat"
  "exa"
  "taskwarrior"
  "timewarrior"
  "cmatrix"
)

PIP_GLOBAL_PACKAGES=(
  "wheel"
  "neovim"
  "virtualenv"
)

NPM_GLOBAL_PACKAGES=(
  "neovim"
)

pkg_bulk_install "${PKG_ESSENTIALS_PACKAGES[@]}"
pkg_bulk_install "${PKG_MISC_PACKAGES[@]}"
pip_bulk_install 3 "${PIP_GLOBAL_PACKAGES[@]}"
npm_bulk_install 1 "${NPM_GLOBAL_PACKAGES[@]}"


############### Shell ################

pkg_install "zsh"

if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
  [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins" ]] && mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
  git_clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git_clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  git_clone "https://github.com/romkatv/powerlevel10k.git" "${HOME}/.oh-my-zsh/themes/powerlevel10k"
fi

# Make sure bash is still default login shell
chsh -s /bin/bash


#################### Dotfiles ####################

# Personal Neovim config files
if git_clone "https://github.com/marklcrns/nvim-config" "${HOME}/.config/nvim/"; then
  git checkout termux
  make
fi

# Clone Vimwiki wikis
[[ -d "${HOME}/Docs/wiki" ]] && rm -rf ~/Docs/wiki
[[ ! -d "${HOME}/Docs" ]] && mkdir -p "${HOME}/Docs"
git_clone "https://github.com/marklcrns/wiki" "${HOME}/Docs/wiki" && \
  git_clone "https://github.com/marklcrns/wiki-wiki" "${HOME}/Docs/wiki/wiki"

# Personal Timewarrior configuration files
git_clone "https://github.com/marklcrns/.timewarrior" "${HOME}/.timewarrior"

pip3 install --user git+git://github.com/tbabej/tasklib@develop
if git_clone "https://github.com/marklcrns/.task" "${HOME}/.task"; then
  # Create .taskrc symlink into $HOME
  [[ -e "${HOME}/.taskrc" ]] && rm "${HOME}/.taskrc"
  ln -s "${HOME}/.task/.taskrc" "${HOME}/.taskrc"

  # Install taskwarrior_time_tracking_hook and symlink into ~/.task/hooks
  if pip_install 3 "taskwarrior-time-tracking-hook"; then
    [[ -e "${HOME}/.task/hooks/on-modify.timetracking" ]] && rm "${HOME}/.task/hooks/on-modify.timetracking"
    ln -s `which taskwarrior_time_tracking_hook` "${HOME}/.task/hooks/on-modify.timetracking"
  fi
fi

if git clone https://github.com/marklcrns/scripts $HOME/scripts; then
  cd ~/.dotfiles
  # Distribute all dotfiles from `~/.dotfiles` into `$HOME` directory
  $HOME/scripts/tools/dotfiles/dotdist -VD -r .dotfilesrc . $HOME

  # Source .profile
  source ${HOME}/.profile
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

finish 'INSTALLATION COMPLETE!'

