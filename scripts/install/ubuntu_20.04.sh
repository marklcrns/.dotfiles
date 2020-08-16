#!/bin/bash

# INSTALLER SCRIPT FOr UBUNTU 20.04 FOCAL FOSSA
#
# Store dotfiles repo in ~/Projects/.dotfiles
#
# For Java Oracle JDK 11, Download Java SE that matches default-jdk installation
# if the one provided in the install directory is not matched:
# https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
# for previous versions:
# https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html
# TODO: More checks





################################################## CONSTANT GLOBAL VARIABLES ###

LOG_FILE_DIR="${HOME}/log"
LOG_FILE="$(date +"%Y-%m-%dT%H:%M:%S")_$(basename -- $0).log"

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})

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
if [[ -e "${SCRIPTDIR}/install_utils.sh" ]]; then
  source "${SCRIPTDIR}/install_utils.sh"
else
  echo "${SCRIPTPATH} ERROR: Failed to source './install_utils.sh' dependency"
  exit 1
fi

# Packages to install
if [[ -e "${SCRIPTDIR}/packages.sh" ]]; then
  source "${SCRIPTDIR}/packages.sh"
else
  echo "${SCRIPTPATH} ERROR: Failed to source './packages.sh' dependency"
  exit 1
fi

############################################################### FLAG OPTIONS ###

# Display help
usage() {
  cat << EOF
USAGE:

Command description.

  command [ -DsvVy ]

OPTIONS:

  -D  debug mode (redirect output in log file)
  -s  silent output
  -v  verbose output
  -V  very verbose output
  -y  skip confirmation
  -h  help

EOF
}

# Set flag options
while getopts "DsvVyh" opt; do
  case "$opt" in
    D) [[ -n "$DEBUG"           ]] && unset DEBUG                      || DEBUG=true;;
    s) [[ -n "$IS_SILENT"       ]] && unset IS_SILENT                  || IS_SILENT=true;;
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

DOTFILES_DIR="$SCRIPTDIR/../.."
DOWNLOADS_DIR="${HOME}/Downloads"
TRASH_DIR="${HOME}/.Trash"

[[ ! -d "${HOME}/Projects" ]] && mkdir -p "${HOME}/Projects"
[[ ! -d "${HOME}/Downloads" ]] && mkdir -p "${DOWNLOADS_DIR}"
[[ ! -d "${HOME}/.Trash" ]] && mkdir -p "${TRASH_DIR}"

cd ${DOWNLOADS_DIR}

#TODO: TEMPORARY FOR WSL
# Nameserver workaround for WSL2
# Creates resolve.conf backup to $HOME as nameserver.txt
cat /etc/resolv.conf > ~/nameserver.txt
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Apt update and upgrade
if sudo apt update -y; then
  error "Apt update failed" 1
fi
if sudo apt upgrade -y; then
  error "Apt upgrade failed" 1
fi

echolog
echolog "${UL_NC}Installing Essential Packages${NC}"
echolog

sudo ufw enable
sudo apt-add-repository universe -y

apt_bulk_install "${APT_PACKAGES_ESSENTIAL[@]}"

echolog
echolog "${UL_NC}Installing Language Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_LANGUAGE[@]}"

# Python2 pip (OPTIONAL)
# Ref: https://linuxize.com/post/how-to-install-pip-on-ubuntu-20.04/
curl_install "https://bootstrap.pypa.io/get-pip.py" "${DOWNLOADS_DIR}/get-pip.py"
execlog "sudo python ${DOWNLOADS_DIR}/get-pip.py"

pip_bulk_install 3 "${PIP3_PACKAGES_LANGUAGES[@]}"

export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64
## Set java and javac 11 as default
sudo update-alternatives --set java ${JDK_HOME}/bin/java
sudo update-alternatives --set javac ${JDK_HOME}/bin/javac

# Copy the Java path excluding the 'bin/java' to environment if not exist
grep -q 'JAVA_HOME=' /etc/environment && \
  sudo sed -i "s,^JAVA_HOME=.*,JAVA_HOME=${JDK_HOME}/jre/," /etc/environment || \
  echo "JAVA_HOME=${JDK_HOME}/jre/" | sudo tee -a /etc/environment
source environ
source /etc/environment

## Oracle JDK 11.0.7
# cd $SCRIPTDIR/install/
# sudo cp jdk-11.0.7_linux-x64_bin.tar.gz /var/cache/oracle-jdk11-installer-local && \
#   echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu focal main" | \
#   sudo tee /etc/apt/sources.list.d/linuxuprising-java.list && \
#   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A && \
#   sudo apt update && \
#   sudo apt install oracle-java11-installer-local -y && \
#   sudo apt install oracle-java11-set-default-local -y && \
#   sudo update-alternatives --set java /usr/lib/jvm/java-11-oracle/bin/java

# # copy the Java path excluding the 'bin/java' if not exist
# grep -q 'JAVA_HOME=' /etc/environment && \
#   sudo sed -i 's,^JAVA_HOME=.*,JAVA_HOME="/usr/lib/jvm/java-11-oracle/",' /etc/environment || \
#   echo 'JAVA_HOME="/usr/lib/jvm/java-11-oracle/"' | sudo tee -a /etc/environment
# source /etc/environment

#################### Package Managers ####################

echolog
echolog "${UL_NC}Installing Package Manager Packages${NC}"
echolog

NVM/NodeJS
if curl_install "https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"; then
  LATESTNPM=`nvm ls-remote | tail -1 | sed 's/^.*\(v[0-9\.]\)/\1/'`
  ## install latest npm
  nvm install $LATESTNPM
  nvm use $LATESTNPM
  nvm alias default $LATESTNPM
fi

Yarn (Needs to go before APT_PACKAGES_PACKAGE_MANAGER installation)
curl_install "https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt_bulk_install "${APT_PACKAGES_PACKAGE_MANAGER[@]}"
npm_bulk_install "${NPM_PACKAGES_PACKAGE_MANAGER[@]}"

############### Shell ################


apt_bulk_install "${APT_PACKAGES_SHELL[@]}"

# Oh-my-zsh, plugins and themes
if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
  git_clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git_clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  git_clone "https://github.com/romkatv/powerlevel10k.git" "${HOME}/.oh-my-zsh/themes/powerlevel10k"
fi

#################### Session Manager ####################

apt_bulk_install "${APT_PACKAGES_SESSION_MANAGER[@]}"
pip_bulk_install 3 "${PIP3_PACKAGES_SESSION_MANAGER[@]}"

# Tmuxinator
git_clone "https://github.com/marklcrns/.tmuxinator" "${HOME}/.tmuxinator"
# Tmux plugin manager
git_clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"


#################### File Manager ####################

apt_bulk_install "${APT_PACKAGES_FILE_EXPLORER[@]}"

# Copy default ranger config
ranger --copy-config=all
# Devicons
git_clone "https://github.com/alexanderjeurissen/ranger_devicons" "${HOME}/.config/ranger/plugins/ranger_devicons"



############### Text Editors ##################

apt_bulk_install "${APT_PACKAGES_TEXT_EDITOR[@]}"
npm_bulk_install 1 "${NPM_PACKAGES_TEXT_EDITOR[@]}"


# Install python and python3 env in nvim root directory
cd ${HOME}/.config/nvim
## python3 host prog
mkdir -p env/python3 && cd env/python3
python3 -m venv env && \
  source env/bin/activate && \
  pip_bulk_install 3 "${PIP3_PACKAGES_TEXT_EDITOR_NEOVIM[@]}" && \
  deactivate

## python2 host prog (DEPRECATED)
# mkdir -p env/python && cd env/python
# python -m venv env && \
#   source env/bin/activate && \
#   pip install neovim tasklib send2trash vim-vint flake8 pylint autopep8 && \
#   deactivate

# Personal neovim config files
git_clone "https://github.com/marklcrns/ThinkVim" "${HOME}/.config/nvim/"

## Clone Vimwiki wikis
[[ -d "${HOME}/Docs/wiki" ]] && rm -rf ~/Docs/wiki
git_clone "https://github.com/marklcrns/wiki" "${HOME}/Docs/wiki" && \
  git_clone "https://github.com/marklcrns/wiki-wiki" "${HOME}/Docs/wiki/wiki"

## Kite
# bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"


#################### Fonts ####################

sudo cp "${SCRIPTDIR}/../../fonts/Haskplex-Nerd-Regular.ttf" /usr/local/share/fonts
sudo cp "${SCRIPTDIR}/../../fonts/Sauce Code Pro Nerd Font Complete.ttf" /usr/local/share/fonts

#################### Utilities ####################

apt_bulk_install "${APT_PACKAGES_UTILITY[@]}"

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

  apt_bulk_install "${APT_PACKAGES_UTILITY_CTAGS_DEPENDENCIES[@]}"

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

#################### Browser ####################

# Google Chrome
if wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"; then
  sudo apt install ./google-chrome-stable_current_amd64.deb
fi

#################### Web Server (LAMP) and Other ####################

apt_bulk_install "${APT_PACKAGES_WEB_SERVER[@]}"

## create backup of apache2.conf and copy www dir to ~/Projects/www
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
# Append only if not already
# Ref: https://superuser.com/a/1314183
sudo grep -q "<Directory /home/$(id -un)/Projects/www>" /etc/apache2/apache2.conf || \
  sudo sed -i "\$i<Directory /home/$(id -un)/Projects/www>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>\n" /etc/apache2/apache2.conf
  # resolve "forbidden You don't have permission to access / on this server" issue
  # Solution: https://askubuntu.com/a/738527
  # Resources:
  # https://unix.stackexchange.com/questions/26284/how-can-i-use-sed-to-replace-a-multi-line-string
  # https://stackoverflow.com/questions/11234001/replace-multiple-lines-using-sed
  # TODO: Fix. Multiple \n match does not work
  # sudo sed 'N; s/<Directory \/>\n\tOptions FollowSymLinks\n\tAllowOverride None\n\tRequire all denied/<Directory \/>\n\tOptions Indexes FollowSymLinks Includes ExecCGI\n\tAllowOverride all\n\tRequire all granted/g' \
  #  /etc/apache2/apache2.conf

  cp -r /var/www ${HOME}/Projects/
  mkdir -p ${HOME}/Projects/www/default
  # replace DocumentRoot in /etc/apache2/sites-enabled/000-default.conf
  # Modify only if not already
  sudo grep -qF "# DocumentRoot /var/www/html" /etc/apache2/sites-enabled/000-default.conf || \
    sudo sed -i "s,DocumentRoot /var/www/html,# DocumentRoot /var/www/html\n\tDocumentRoot /home/$(id -un)/Projects/www/default," \
    /etc/apache2/sites-enabled/000-default.conf
      echo "<h1>This is Apache2 default site</h1>" > ~/Projects/www/default/index.html
      sudo service apache2 restart

# MySQL
if apt_install "mysql-server" && apt_install "mysql-client" -y; then
  ## When passsword prompt:
  ## Password valdation: Low `0`
  ## Then Answer `y` for the rest of the question prompts
  sudo service mysql start && sudo mysql_secure_installation
fi

# PHP
if apt_bulk_install "${APT_PACKAGES_WEB_SERVER_PHP_DEPENDENCIES[@]}"; then
  echo '<?php\nphpinfo();\n?>' > ~/Projects/www/default/info.php
fi

# PhpMyAdmin
# Ref: https://www.fosslinux.com/6745/how-to-install-phpmyadmin-with-lamp-stack-on-ubuntu.htm
# MYSQL application password for phpmyadmin set up
if sudo service mysql start; then # its IMPORTANT that mysql is running before installing
  # PhpMyAdmin Prompt:
  # apache2
  # Yes
  apt_install phpmyadmin
fi

#################### Virtual Machine/Containers ####################

# # Vagrant 2.2.9
# if wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb; then
#   sudo dpkg -i vagrant_2.2.9_x86_64.deb
#   sudo apt -f install
# fi

#################### Misc ####################

apt_bulk_install "${APT_PACKAGES_MISC[@]}"

# Battery saving tool
apt_install tlp && sudo tlp start

# Tldr
mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr && \
  chmod +x ~/bin/tldr

# Taskwarrior & Timewarrior
if apt_install taskwarrior timewarrior -y; then
  pip3 install --user git+git://github.com/tbabej/tasklib@develop && \
  pip install --user git+git://github.com/tbabej/tasklib@develop
  # Personal Timewarrior configuration files
  git_clone "https://github.com/marklcrns/.timewarrior" "${HOME}/.timewarrior"
  # Taskwarrior hooks
  if git clone https://github.com/marklcrns/.task ~/.task; then
    ln -s ${HOME}/.task/.taskrc ${HOME}/.taskrc && \
      cd ${HOME}/.task/hooks && \
        sudo chmod +x on-modify-pirate on-add-pirate on-modify.timewarrior
    if pip_install 3 "taskwarrior-time-tracking-hook"; then
      ln -s `which taskwarrior_time_tracking_hook` "~/.task/hooks/on-modify.timetracking"
    fi
  fi
fi


#################### MIME Applications ####################

# cd $DOTFILES

# Custom MIME handlers
# cp .config/mimeapps.list ~/.config/
# mkdir ~/.local/share/applications
# cp applications/* ~/.local/share/applications/
# ln -sf ~/.config/mimeapps.list ~/.local/share/applications/mimeapps.list


#################### Desktop Apps ####################

apt_bulk_install ${APT_PACKAGES_DESKTOP_APPLICATION[@]}

# Peek
if sudo add-apt-repository ppa:peek-developers/stable -y; then
  apt_install peek
fi

# # Wine
# ## Installation
# sudo dpkg --add-architecture i386
# if wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -; then
#   if sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' -y; then
#     apt_install "--install-recommends winehq-stable" 1
#     # Setup
#     winecfg
#   fi
#   # PlayOnLinux
#   apt_install playonlinux
# fi


#################### Windows Manager ####################

# DWM
# Ref: https://medium.com/hacker-toolbelt/dwm-windows-manager-in-ubuntu-14958224a782
## If asked, choose XDM as display manager (you can even remove gdm3: sudo apt-get remove gdm3)
# if apt_bulk_install "${APT_PACKAGES_DESKTOP_WINDOW_MANAGER[@]}"; then
#   echo dwm > ${HOME}.xsession
# fi



exit 0





#################### Dotfiles ####################

# Distribute dotfiles
source ../.bash_aliases
dotdist

# source bashrc
source ~/.bashrc


#################################################################### WRAP UP ###

finish 'INSTALLATION COMPLETE!'

