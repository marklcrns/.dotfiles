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

echo "The following packages are about to be installed:"
echo apache2
echo atool
echo autoconf
echo automake
echo build-essential
echo caca-utils
echo cmatrix
echo curl
echo default-jdk
echo default-jre
echo emacs
echo fd-find
echo gawk
echo gcc
echo git
echo git-lfs
echo gnupg2
echo google-chrome-stable
echo highlight
echo htop
echo inotify-tools
echo kite
echo libapache2-mod-php
echo libffi-dev
echo libjansson-dev
echo libreoffice
echo libseccomp-dev
echo libsqlite3-dev
echo libssl-dev
echo libxml2-dev
echo libyaml-dev
echo make
echo mlocate
echo mysql-client
echo mysql-server
echo mysql-workbench
echo neofetch
echo neovim
echo oracle-java11-set-default-local
echo pandoc
echo pandoc-data
echo php
echo php-bcmath
echo php-cli
echo php-curl
echo php-fpm
echo php-gd
echo php-json
echo php-mbstring
echo php-mysql
echo php-pdo
echo php-pear
echo php-xml
echo php-zip
echo phpmyadmin
echo pkg-config
echo python2
echo python2-pip
echo python3-docutils
echo python3-neovim
echo python3-pip
echo python3-venv
echo r-base
echo ranger
echo rclone-browser
echo ripgrep
echo screenfetch
echo software-properties-common
echo sqlite3
echo sqlitebrowser
echo synaptic
echo taskwarrior
echo texlive
echo timewarrior
echo tlp
echo tmux
echo tmuxinator
echo tree
echo unzip
echo urlview
echo vagrant
echo vim
echo virtualbox
echo w3m
echo w3m-img
echo wget
echo xclip
echo xdg-utils
echo xdotool
echo yad
echo yarn
echo zathura
echo zenity
echo zip
echo zsh
echo

# Ref: https://stackoverflow.com/a/1885534/11850077
read -p "Proceed installing? (Y/y)" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo Aborting...
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

# Save script location
SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"

# Save dotfiles location
DOTFILES=$SCRIPTDIR/..

cd ~
[[ ! -d "${HOME}/Downloads" ]] && mkdir ~/Downloads
[[ ! -d "${HOME}/.Trash" ]] && mkdir ~/.Trash


################ Essentials #######################

# Enable firewall
sudo ufw enable

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential libssl-dev libffi-dev -y
sudo apt install software-properties-common -y
sudo apt-add-repository universe -y
sudo apt install curl wget zip unzip git vim -y
sudo apt install gnupg2


#################### Languages ####################

cd ~/Downloads

# Python 2 (DEPRECATED, Ubuntu 20.04 on longer supports older python)
# Uncomment if you still want to install old python from universe repository
sudo apt install python-dev -y
## Python2 pip
## Ref: https://linuxize.com/post/how-to-install-pip-on-ubuntu-20.04/
curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
sudo python get-pip.py

# Python3
sudo apt install python3-dev python3-pip python3-venv -y
# Python Modules
pip3 install notebook
pip3 install Send2Trash # included in notebook module
pip3 install pipenv

# Java
# Ref:
# https://www.itzgeek.com/post/how-to-install-java-on-ubuntu-20-04/
# https://linuxize.com/post/install-java-on-ubuntu-20-04/
## OpenJDK 8, 11, 13
sudo apt install openjdk-8-jdk openjdk-8-jre -y
sudo apt install openjdk-11-jdk openjdk-11-jre -y
sudo apt install openjdk-13-jdk openjdk-13-jre -y

export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64
## Set java and javac 11 as default
sudo update-alternatives --set java ${JDK_HOME}/bin/java
sudo update-alternatives --set javac ${JDK_HOME}/bin/javac

## Copy the Java path excluding the 'bin/java' to environment if not exist
grep -q 'JAVA_HOME=' /etc/environment && \
  sudo sed -i "s,^JAVA_HOME=.*,JAVA_HOME=${JDK_HOME}/jre/," /etc/environment || \
  echo "JAVA_HOME=${JDK_HOME}/jre/" | sudo tee -a /etc/environment
# source environ
source /etc/environment

# ## Oracle JDK 11.0.7
# sudo apt install default-jre default-jdk -y
# cd $SCRIPTDIR/install/
# sudo cp jdk-11.0.7_linux-x64_bin.tar.gz /var/cache/oracle-jdk11-installer-local && \
#   echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu focal main" | \
#   sudo tee /etc/apt/sources.list.d/linuxuprising-java.list && \
#   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A && \
#   sudo apt update && \
#   sudo apt install oracle-java11-installer-local -y && \
#   sudo apt install oracle-java11-set-default-local -y && \
#   sudo update-alternatives --set java /usr/lib/jvm/java-11-oracle/bin/java
## copy the Java path excluding the 'bin/java' if not exist
# grep -q 'JAVA_HOME=' /etc/environment && \
#   sudo sed -i 's,^JAVA_HOME=.*,JAVA_HOME="/usr/lib/jvm/java-11-oracle/",' /etc/environment || \
#   echo 'JAVA_HOME="/usr/lib/jvm/java-11-oracle/"' | sudo tee -a /etc/environment
# source /etc/environment

#################### Package Managers ####################

cd ~/Downloads

# NVM/NodeJS
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && \
  LATESTNPM=`nvm ls-remote | tail -1 | sed 's/^.*\(v[0-9\.]\)/\1/'`
## install latest npm
nvm install $LATESTNPM
nvm use $LATESTNPM
nvm alias default $LATESTNPM

# NPM
sudo apt install npm -y
sudo npm i npm@latest -g
# NPM glob packages (Optional)
sudo npm -g install browser-sync
sudo npm -g install gulp-cli

# yarn
# ref: https://linuxhint.com/install_yarn_ubuntu/
curl -ss https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update -y
sudo apt install yarn -y
## node js is dependent on yarn. if using nodejs and npm run
sudo apt-get install --no-install-recommends yarn


############### Shell ################

cd ~/Downloads

# Zsh, Oh-my-zsh, plugins and themes
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k


#################### Screen Manager ####################

cd ~/Downloads

# Tmux
sudo apt install tmux -y
sudo apt install tmuxinator -y
# Tmuxinator configs
git clone https://github.com/marklcrns/.tmuxinator ~/.tmuxinator
# TPM Plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# dependencies
sudo apt install gawk -y # tmux-fingers
sudo apt install urlview -y # tmux-urlview
pip3 install spotify-cli-linux # tmux-plugin-spotify


#################### File Manager ####################

cd ~/Downloads

# Ranger
sudo apt install ranger -y
ranger --copy-config=all # copy default config
# Devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons \
  ~/.config/ranger/plugins/ranger_devicons
# Preview packages that works well with ranger
sudo apt install caca-utils highlight atool w3m w3m-img zathura xdotool \
  poppler-utils mediainfo mupdf mupdf-tools -y


############### Text Editors ##################

cd ~/Downloads

# Neovim
sudo apt install neovim -y
# sudo apt install python-neovim -y # (DEPRECATED, not found)
sudo apt install python3-neovim -y
sudo npm install -g neovim
## configs
git clone https://github.com/marklcrns/ThinkVim ~/.config/nvim/
## other tools and dependencies
sudo apt install yad zenity -y
cd ~/.config/nvim
## python3 host prog
mkdir -p env/python3 && cd env/python3
python3 -m venv env && \
  source env/bin/activate && \
  pip3 install neovim tasklib send2trash vim-vint flake8 pylint autopep8 && \
  deactivate

## python2 host prog (DEPRECATED)
# mkdir -p env/python && cd env/python
# python -m venv env && \
#   source env/bin/activate && \
#   pip install neovim tasklib send2trash vim-vint flake8 pylint autopep8 && \
#   deactivate

sudo npm install -g eslint stylelint prettier
cd ~/Downloads

## Clone Vimwiki wikis
[[ -d "${HOME}/Docs/wiki" ]] && rm -rf ~/Docs/wiki
git clone https://github.com/marklcrns/wiki ~/Docs/wiki && \
  git clone https://github.com/marklcrns/wiki-wiki ~/Docs/wiki/wiki

## Kite
bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"

# # Emacs
# sudo apt install emacs -y
# ## Doom Emacs
# git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d && \
#   ~/.emacs.d/bin/doom install


#################### Fonts ####################

cd $DOTFILES

sudo cp "fonts/Haskplex-Nerd-Regular.ttf" /usr/local/share/fonts
sudo cp "fonts/Sauce Code Pro Nerd Font Complete.ttf" /usr/local/share/fonts


#################### Utilities ####################

cd ~/Downloads

# Command line utils
sudo apt install tree xclip xdg-utils fd-find mlocate autojump k-y

# Synaptic
sudo apt install synaptic

# Rclone
curl https://rclone.org/install.sh | sudo bash && \
  sudo apt install rclone-browser -y

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install

# Ripgrep
sudo apt install ripgrep -y

# Bat v0.15.4 (Manual)
# Ref: https://github.com/sharkdp/bat#on-ubuntu
BAT_VERSION="0.15.4"
curl -LO "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb" && \
  sudo dpkg -i "bat_${BAT_VERSION}_amd64.deb"

# Universal-ctags
## Dependencies
sudo apt install gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev -y
## Installation
git clone https://github.com/universal-ctags/ctags.git --depth=1 && \
  cd ctags && \
  ./autogen.sh && \
  ./configure && \
  make && \
  sudo make install && \
  cd ..

# Git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
  sudo apt install git-lfs -y && \
  git lfs install

# Lazygit
sudo add-apt-repository ppa:lazygit-team/release
sudo apt-get update
sudo apt-get install lazygit

# Pandoc & others
sudo apt install pandoc-data pandoc texlive -y
## R-Pandoc
### dependencies
sudo apt install r-base -y
curl -sSL https://get.haskellstack.org/ | sh
### installation
git clone https://github.com/cdupont/R-pandoc.git && \
  cd R-pandoc && \
  stack install
## clone configs
git clone https://github.com/marklcrns/pandoc-goodies ~/.pandoc
cd ..

# Exa
## dependencies
curl https://sh.rustup.rs -sSf | sh
## installation
wget -c https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip && \
  unzip exa-linux-x86_64-0.9.0.zip && \
  sudo mv exa-linux-x86_64 /usr/local/bin/exa

# Inotify-tools
sudo apt install inotify-tools -y

#################### Browser ####################

cd ~/Downloads

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  sudo apt install ./google-chrome-stable_current_amd64.deb

#################### Web Server (LAMP) ####################

cd ~/Downloads

# Apache 2
sudo apt update -y
sudo apt install apache2 apache2-utils -y
## create backup of apache2.conf and copy www dir to ~/Projects/www
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
# Append only if not already
sudo grep -qF '<Directory ~/Projects/www>' /etc/apache2/apache2.conf || \
  sudo sed -i '$i<Directory ~/Projects/www>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>\n' /etc/apache2/apache2.conf
# resolve "forbidden You don't have permission to access / on this server" issue
# Solution: https://askubuntu.com/a/738527
# Resources:
# https://unix.stackexchange.com/questions/26284/how-can-i-use-sed-to-replace-a-multi-line-string
# https://stackoverflow.com/questions/11234001/replace-multiple-lines-using-sed
# TODO: Fix. Multiple \n match does not work
# sudo sed 'N; s/<Directory \/>\n\tOptions FollowSymLinks\n\tAllowOverride None\n\tRequire all denied/<Directory \/>\n\tOptions Indexes FollowSymLinks Includes ExecCGI\n\tAllowOverride all\n\tRequire all granted/g' \
#  /etc/apache2/apache2.conf

cp -r /var/www ~/Projects/
mkdir -p ~/Projects/www/default
# replace DocumentRoot in /etc/apache2/sites-enabled/000-default.conf
# Modify only if not already
sudo grep -qF "# DocumentRoot /var/www/html" /etc/apache2/sites-enabled/000-default.conf || \
  sudo sed -i 's,DocumentRoot /var/www/html,# DocumentRoot /var/www/html\n\tDocumentRoot ~/Projects/www/default,' \
  /etc/apache2/sites-enabled/000-default.conf
echo "<h1>This is Apache2 default site</h1>" > ~/Projects/www/default/index.html
sudo service apache2 restart

# MySQL
sudo apt install mysql-server mysql-client -y && \
  sudo service mysql start && \
  sudo mysql_secure_installation # This will promt for the installation setup
## When passsword prompt:
## Password valdation: Low `0`
## Then Answer `y` for the rest of the question prompts
## MYSQL Workbench

# package not found
# sudo apt install mysql-workbench -y

# PHP
sudo apt install php libapache2-mod-php php-cli php-fpm php-json php-pdo \
  php-mysql php-zip php-gd  php-mbstring php-curl php-xml php-pear php-bcmath -y
  echo '<?php\nphpinfo();\n?>' > ~/Projects/www/default/info.php

# ## PhpMyAdmin
# ## Ref: https://www.fosslinux.com/6745/how-to-install-phpmyadmin-with-lamp-stack-on-ubuntu.htm
# # MYSQL application password for phpmyadmin set up
# sudo service mysql start # its IMPORTANT that mysql is running before installing
# sudo apt install phpmyadmin -y
# ### PhpMyAdmin Prompt
# # apache2
# # Yes


#################### Web Server (Others) ####################

cd ~/Downloads

# SQLite3 && SQLite browser
sudo apt install sqlite3 libsqlite3-dev sqlitebrowser -y


#################### Virtual Machine/Containers ####################

cd ~/Downloads

# Ref: https://computingforgeeks.com/install-latest-vagrant-on-ubuntu-debian-kali-linux/
# Vagrant 2.2.9
wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb && \
  sudo dpkg -i vagrant_2.2.9_x86_64.deb && \
  sudo apt -f install

# VirtualBox
sudo apt install virtualbox -y
## dependencies
sudo apt install virtualbox-dkms linux-headers-generic linux-headers-$(uname -r) -y

# Docker
sudo apt install docker.io


#################### Windows Manager ####################

# DWM
# Ref: https://medium.com/hacker-toolbelt/dwm-windows-manager-in-ubuntu-14958224a782
## If asked, choose XDM as display manager (you can even remove gdm3: sudo apt-get remove gdm3)
# sudo apt install dwm suckless-tools xdm dmenu xorg && \
#   echo dwm > .xsession


#################### Misc ####################

cd ~/Downloads

sudo apt install screenfetch neofetch htop cmatrix -y

# Battery saving tool
sudo apt install tlp && sudo tlp start

# Tldr
mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr && \
  chmod +x ~/bin/tldr

# Taskwarrior & Timewarrior
sudo apt install taskwarrior timewarrior -y && \
  pip3 install --user git+git://github.com/tbabej/tasklib@develop && \
  pip install --user git+git://github.com/tbabej/tasklib@develop
## Timewarrior configs
git clone https://github.com/marklcrns/.timewarrior ~/.timewarrior
# Taskwarrior hooks
git clone https://github.com/marklcrns/.task ~/.task && \
  ln -s ~/.task/.taskrc ~/.taskrc && \
  cd ~/.task/hooks && \
  sudo chmod +x on-modify-pirate on-add-pirate on-modify.timewarrior
pip3 install taskwarrior-time-tracking-hook && \
  ln -s `which taskwarrior_time_tracking_hook` ~/.task/hooks/on-modify.timetracking


#################### MIME Applications ####################

# cd $DOTFILES

# Custom MIME handlers
# cp .config/mimeapps.list ~/.config/
# mkdir ~/.local/share/applications
# cp applications/* ~/.local/share/applications/
# ln -sf ~/.config/mimeapps.list ~/.local/share/applications/mimeapps.list


#################### Desktop Apps ####################

cd ~/Downloads

# Libre Office
sudo apt install libreoffice -y

# Flameshot
sudo apt install flameshot -y

# GIMP
sudo apt install gimp -y

# Peek
sudo add-apt-repository ppa:peek-developers/stable -y
sudo apt update -y
sudo apt install peek -y

# Wine
## Installation
sudo dpkg --add-architecture i386
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update -t
sudo apt install --install-recommends winehq-stable -y
# Setup
winecfg

# PlayOnLinux
sudo apt install playonlinux -y

#################### Dotfiles ####################

# Backup dotfiles (creates ~/.YY-MM-DD_old.bak directory)
cd ${HOME}
DOTBACKUPDIR=${HOME}/.`date -u +"%Y-%m-%dT%H:%M:%S"`_old_dotfiles.bak
mkdir ${DOTBACKUPDIR}
mkdir ${DOTBACKUPDIR}/.config ${DOTBACKUPDIR}/.vim
cp -r \
  bin \
  .bashrc .bash_aliases .profile \
  .zshenv .zshrc \
  .tmux.conf \
  .gitconfig \
  .ctags \
  .ctags.d/ \
  .mutt/ \
  .scimrc \
  ${DOTBACKUPDIR}
cp -r \
  ~/.config/ranger/ \
  ~/.config/zathura/ \
  ${DOTBACKUPDIR}/.config
cp -r .vim/session ${DOTBACKUPDIR}/.vim
# Check if WSL
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  # 2>/dev/null to suppress UNC paths are not supported error
  WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
  cp -r "/mnt/c/Users/${WIN_USERNAME}/Documents/.gtd/" ${DOTBACKUPDIR}
  cp ~/.config/mimeapps.list ${DOTBACKUPDIR}/.config
else
  cp -r ~/.gtd/ ${DOTBACKUPDIR}
fi
cd -; printf "\n${GREEN}DOTFILES BACKUP COMPLETE...${NC}\n\n"

# Distribute dotfiles
cd ${DOTFILES}
cp -r \
  .bashrc .bash_aliases .profile \
  .zshenv .zshrc \
  .tmux.conf \
  .gitconfig \
  .ctags \
  .ctags.d/ \
  .mutt/ \
  .scimrc \
  ${HOME}
rm -rf ~/.vim/session; cp -r .vim/session ~/.vim
rm -rf ~/bin; cp -r bin ~/bin
rm -rf ~/.config/{ranger,zathura}; cp -r \
  .config/ranger/ \
  .config/zathura/ \
  ~/.config
# Check if WSL
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  # 2>/dev/null to suppress UNC paths are not supported error
  WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
  cp -r .gtd /mnt/c/Users/${WIN_USERNAME}/Documents
  cp .config/mimeapps.list ~/.config
else
  cp -r .gtd ${HOME}
fi
cd -; printf "\n${GREEN}DOTFILES DISTRIBUTION COMPLETE...${NC}\n\n"

# source bashrc
source ~/.bashrc

# restore nameserver
cat ~/nameserver.txt | sudo tee /etc/resolv.conf

printf '\nINSTALLATION COMPLETE!\n\n'
