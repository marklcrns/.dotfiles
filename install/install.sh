#!/bin/bash

# INSTALLER SCRIPT FOr WSL2 UBUNTU 20.04 FOCAL FOSSA
# Creates ~/Downloads directory for installers package
# Stores dotfiles repo in ~/Projects/dotfiles

# For Java Oracle JDK 11, Download Java SE that matches default-jdk installation
# if the one provided in the install directory is not matched here:
# https://www.oracle.com/java/technologies/javase-jdk11-downloads.html

echo "The following packages are about to be installed:"
echo apache2
echo atool
echo autoconf
echo automake
echo build-essential
echo caca-utils
echo cmatrix
echo curl
echo dbus-x11
echo default-jdk
echo default-jre
echo emacs
echo fd-find
echo gawk
echo gcc
echo git
echo git-lfs
echo google-chrome-stable
echo highlight
echo htop
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
echo python3-dev
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
echo taskwarrior
echo texlive
echo timewarrior
echo tmux
echo tmuxinator
echo tree
echo unzip
echo urlview
echo w3m
echo w3m-img
echo wget
echo xclip
echo xdg-utils
echo xdotool
echo xfce4
echo xubuntu-desktop
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

#Save script location
BASEDIR="$( cd "$( dirname "$0" )" && pwd )"

cd ~
mkdir ~/Downloads

# Nameserver workaround for WSL2
# Creates resolve.conf backup to $HOME as nameserver.txt
cat /etc/resolv.conf > ~/nameserver.txt
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf


################ Essentials #######################

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential libssl-dev libffi-dev -y
sudo apt install software-properties-common -y
sudo apt-add-repository universe -y
sudo apt install curl wget zip unzip git -y

# XServer
sudo apt install dbus-x11 -y
sudo systemd-machine-id-setup


#################### Languages ####################

# Python (DEPRECATED, Ubuntu 20.04 on longer supports older python)
# Uncomment if you still want to install old python from universe repository
# sudo apt install python-dev -y
# Python3
sudo apt install python3-dev python3-pip python3-venv -y
# Python Modules
pip3 install notebook
pip3 install Send2Trash # included in notebook module
pip3 install pipenv

# Java
# Ref: https://www.itzgeek.com/post/how-to-install-java-on-ubuntu-20-04/
## Latest JRE & JDK 11
sudo apt install default-jre default-jdk -y
## Oracle JDK 11.0.7
cd $BASEDIR/install/
sudo cp jdk-11.0.7_linux-x64_bin.tar.gz /var/cache/oracle-jdk11-installer-local/
echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu focal main" | \
  sudo tee /etc/apt/sources.list.d/linuxuprising-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A
sudo apt update
sudo apt install oracle-java11-installer-local -y
sudo apt install oracle-java11-set-default-local -y
sudo update-alternatives --set java /usr/lib/jvm/java-11-oracle/bin/java
## copy the Java path excluding the 'bin/java' if not exist
grep -qxF 'JAVA_HOME="/usr/lib/jvm/java-11-oracle/"' /etc/environment || \
  echo 'TEST="/usr/lib/jvm/java-11-oracle/"' | sudo tee -a /etc/environment && \
  source /etc/environment


#################### Package Managers ####################

cd ~/Downloads

# NVM/NodeJS
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && \
  LATESTNPM=`nvm ls-remote | tail -1 | sed 's/^.*\(v[0-9\.]\)/\1/'`
  nvm install $LATESTNPM
  nvm use $LATESTNPM
  nvm alias default $LATESTNPM

# NPM
sudp apt install npm -y
npm i npm@latest -g
# NPM glob packages (Optional)
npm -g install browser-sync
npm -g install gulp-cli

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update -y
sudo apt install yarn -y


############### Shell ################

cd ~/Downloads

# Zsh, Oh-my-zsh, plugins and themes
sudo apt install zsh -y
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k


#################### Screen Manager ####################

cd ~/Downloads

# Tmux
sudo apt install tmux -y
sudo apt install tmuxinator -y
# TPM Plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# dependencies
sudo apt install gawk -y # tmux-fingers
sudo apt install urlview -y # tmux-urlview


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


############### Editors ##################

cd ~/Downloads

# Neovim
sudo apt install neovim -y
# sudo apt install python-neovim # (DEPRECATED)
sudo apt install python3-neovim -y
# configs
git clone https://github.com/marklcrns/ThinkVim ~/.config/nvim/
# other tools and dependencies
sudo apt install yad zenity -y
cd ~/.config/nvim
mkdir -p env/python3 && cd env/python3
python3 -m venv env && \
  source env/bin/activate && \
  pip3 install neovim tasklib send2trash vim-vint flake8 pylint autopep8 && \
  deactivate
npm install -g eslint stylelint prettier

cd ~/Downloads

# Emacs
sudo apt install emacs -y
# Doom Emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d && \
  ~/.emacs.d/bin/doom install

# Libre Office
sudo apt install libreoffice -y


#################### Utilities ####################

cd ~/Downloads

sudo apt install tree xclip xdg-utils fd-find -y

# Rclone
curl https://rclone.org/install.sh | sudo bash && \
  sudo apt install rclone-browser -y

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install

# Ripgrep
sudo apt install ripgrep -y

# Bat v0.15.0 (Manual)
# Ref: https://github.com/sharkdp/bat#on-ubuntu
curl -LO https://github.com/sharkdp/bat/releases/download/v0.15.0/bat_0.15.0_amd64.deb && \
  sudo dpkg -i bat_0.15.0_amd64.deb

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

# Exa
## dependencies
curl https://sh.rustup.rs -sSf | sh
## installation
wget -c https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip && \
  unzip exa-linux-x86_64-0.9.0.zip && \
  sudo mv exa-linux-x86_64 /usr/local/bin/exa


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
sudo apt install mysql-server mysql-client -y
sudo service mysql start
sudo mysql_secure_installation # This will promt for the installation setup
## When passsword prompt:
# Password valdation: Low `0`
# Then Answer `y` for the rest of the question prompts
## MYSQL Workbench
sudo apt install mysql-workbench -y

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

# SQLite3 && SQLite browser
sudo apt install sqlite3 libsqlite3-dev sqlitebrowser -y


#################### Misc ####################

cd ~/Downloads

sudo apt install screenfetch neofetch htop cmatrix -y

# Tldr
mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
chmod +x ~/bin/tldr

# Xfce4
sudo apt install xfce4 xubuntu-desktop -y

# Taskwarrior & Timewarrior
sudo apt install taskwarrior timewarrior -y
pip3 install --user git+git://github.com/tbabej/tasklib@develop
# task hooks
git clone https://github.com/marklcrns/.task ~/.task && \
  ln -s ~/.task/.taskrc ~/.taskrc && \
  cd ~/.task/hooks && \
  sudo chmod +x on-modify-pirate on-add-pirate on-modify.timewarrior
git clone https://github.com/tbabej/task.default-date-time ~/.task/hooks/default-date-time/
pip3 install taskwarrior-time-tracking-hook && \
  ln -s `which taskwarrior_time_tracking_hook` ~/.task/hooks/on-modify.timetracking


#################### Dotfiles ####################

# Backup dotfiles (creates ~/.YY-MM-DD_old.bak directory)
cd ~
cp -r \
  bin \
  .bashrc .bash_aliases .profile \
  .zshenv .zshrc \
  .tmux.conf \
  .gitconfig \
  .ctags \
  .ctags.d/ \
  .mutt/ \
  .vim/ \
  .scimrc \
  .config/ranger/rc.conf \
  .config/zathura/zathurarc \
  /mnt/c/Users/MarkL/Documents/gtd \
  ~/.`date "+%Y-%m-%d"`_old_dotfiles.bak/; \
cd -; printf '\nDOTFILES BACKUP COMPLETE...\n\n'

# Distribute dotfiles
cd $BASEDIR/..
cp -r \
  bin \
  .bashrc .bash_aliases .profile \
  .zshenv .zshrc \
  .tmux.conf \
  .gitconfig \
  .ctags \
  .ctags.d/ \
  .mutt/ \
  .vim/ \
  .scimrc \
  $HOME; \
  cp rc.conf ~/.config/ranger/; \
  cp zathurarc ~/.config/zathura/; \
  cp -r gtd /mnt/c/Users/MarkL/Documents; \
cd -; printf '\nDOTFILES DISTRIBUTION COMPLETE...\n\n'

# source bashrc
source ~/.bashrc

# restore nameserver
cat ~/nameserver.txt | sudo tee /etc/resolv.conf

printf '\nINSTALLATION COMPLETE!\n\n'
