#!/bin/bash

# INSTALLER SCRIPT FOr WSL2 UBUNTU 20.04 FOCAL FOSSA
# Creates ~/Downloads directory for installers package
# Stores dotfiles repo in ~/Projects/dotfiles

# For Java Oracle JDK 11, Download Java SE that matches default-jdk installation
# here: https://www.oracle.com/java/technologies/javase-jdk11-downloads.html

# Save script location
BASEDIR="$( cd "$( dirname "$0" )" && pwd )"

cd ~
mkdir ~/Downloads

# Nameserver workaround for WSL2
# Creates resolve.conf backup at $HOME as namesserver.txt
cat /etc/resolv.conf > ~/nameserver.txt
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf


################ Essentials #######################

sudo apt update && sudo apt upgrade -y
sudo apt install curl wget zip unzip git -y
sudo apt install build-essential libssl-dev libffi-dev -y
sudo apt install software-properties-common -y
sudo apt-add-repository universe -y

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
pip3 install virtualenv
pip3 install pipenv

# Java
# Ref: https://www.itzgeek.com/post/how-to-install-java-on-ubuntu-20-04/
## Latest JRE & JDK 11
sudo apt install default-jre default-jdk -y
## Oracle JDK 11.0.7
cd $BASEDIR
sudo cp ./jdk-11.0.7_linux-x64_bin.tar.gz /var/cache/oracle-jdk11-installer-local/
echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu focal main" | \
  sudo tee /etc/apt/sources.list.d/linuxuprising-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A
sudo apt update
sudo apt-get install oracle-java11-installer-local -y
sudo apt install oracle-java11-set-default-local -y
sudo update-alternatives --set java /usr/lib/jvm/java-11-oracle/bin/java
## copy the Java path excluding the 'bin/java' if not exist
# TODO: append only if not existing
grep -qxF 'JAVA_HOME="/usr/lib/jvm/java-11-oracle/"' /etc/environment | \
  echo 'TEST="/usr/lib/jvm/java-11-oracle/"' | sudo tee -a /etc/environment && \
  source /etc/environment


############### Shell ################

cd ~/Downloads

# Zsh, Oh-my-zsh, plugins and themes
sudo apt install zsh -y
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

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
pip3 install virtualenv
cd ~/.config/nvim
mkdir -p env/python3
virtualenv --python=python3 ./env/python3/env
source ./env/python3/env/bin/activate
pip3 install neovim
pip3 install tasklib
pip3 install send2trash
# checkers & linters
pip3 install vim-vint
pip3 install flake8 pylint autopep8
deactivate
npm install -g eslint stylelint prettier

cd ~/Downloads

# Emacs
sudo apt install emacs -y
# Doom Emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

# Libre Office
sudo apt install libreoffice -y


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


#################### Package Managers ####################

cd ~/Downloads

# NVM/NodeJS
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
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


#################### Utilities ####################

cd ~/Downloads

sudo apt install tree xclip xdg-utils fd-find -y

# Rclone
curl https://rclone.org/install.sh | sudo bash
sudo apt install rclone-browser -y

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
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
git clone https://github.com/universal-ctags/ctags.git --depth=1
cd ctags
./autogen.sh
./configure
make
sudo make install
cd ..

# Git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
  sudo apt install git-lfs -y && \
  git lfs install

# Pandoc & others
sudo apt install pandoc-data pandoc texlive -y
## R-Pandoc
### Dependencies
sudo apt install r-base -y
curl -sSL https://get.haskellstack.org/ | sh
### Installation
git clone https://github.com/cdupont/R-pandoc.git
cd R-pandoc
stack install

# Exa
## Dependencies
curl https://sh.rustup.rs -sSf | sh
## Installation
wget -c https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
unzip exa-linux-x86_64-0.9.0.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa


#################### Browser ####################

cd ~/Downloads

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

#################### Web Server (LAMP) ####################

cd ~/Downloads

# Apache 2
sudo apt update -y
sudo apt install apache2
## create backup of apache2.conf and copy www dir to ~/Projects/www
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
# TODO: Append only if not existing
sudo sed -i '$i<Directory ~/Projects/www>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>\n' /etc/apache2/apache2.conf
# TODO: resolve "forbidden You don't have permission to access / on this server" issue
# Solution: https://askubuntu.com/a/738527
# Resource: https://unix.stackexchange.com/questions/26284/how-can-i-use-sed-to-replace-a-multi-line-string
cp -r /var/www ~/Projects/
mkdir -p ~/Projects/www/default
# replace DocumentRoot in /etc/apache2/sites-enabled/000-default.conf
# TODO: Append only if not existing
sudo sed -i 's,DocumentRoot /var/www/html,# DocumentRoot /var/www/html\n\tDocumentRoot ~/Projects/www/default,' /etc/apache2/sites-enabled/000-default.conf
echo "<h1>This is Apache2 default site</h1>" > ~/Projects/www/default/index.html
sudo service apache2 restart

# MySQL
sudo apt install mysql-server -y
sudo service mysql start
sudo mysql_secure_installation # This will promt for the installation setup
## When passsword prompt:
# Password valdation: Low `0`
# Then Answer `y` for the rest of the question prompts
## MYSQL Workbench
sudo apt install mysql-workbench -y

# PHP
sudo apt install php libapache2-mod-php php-mysql -y
## PhpMyAdmin
sudo service mysql start # its IMPORTANT that mysql is running before installing
sudo apt install phpmyadmin -y
### PhpMyAdmin Prompt
# apache2
# Yes
# MYSQL application password for phpmyadmin set up


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
cd ~/.task/hooks
wget https://raw.githubusercontent.com/tbabej/taskpirate/master/on-modify-pirate
wget https://raw.githubusercontent.com/tbabej/taskpirate/master/on-add-pirate
wget https://raw.githubusercontent.com/GothenburgBitFactory/timewarrior/dev/ext/on-modify.timewarrior
sudo chmod +x on-modify-pirate on-add-pirate on-modify.timewarrior
git clone https://github.com/tbabej/task.default-date-time ~/.task/hooks/default-date-time/
pip3 install taskwarrior-time-tracking-hook
ln -s `which taskwarrior_time_tracking_hook` ~/.task/hooks/on-modify.timetracking
cd ~/Downloads


#################### Dotfiles ####################

# Backup dotfiles
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
  .`date "+%Y-%m-%d"`_old.bak/; \
cd -; echo "\nDOTFILES BACKUP COMPLETE...\n"

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
cd -; echo "\nDOTFILES DISTRIBUTION COMPLETE...\n"

# source bashrc
source ~/.bashrc

# restore nameserver
cat ~/nameserver.txt | sudo tee /etc/resolv.conf

echo "\nINSTALLATION COMPLETE!"
