# config files
alias vimrc='nvim ~/.vim/.vimrc'
alias tmuxconf='nvim ~/.tmux.conf'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias nvimrc='cd ~/.config/nvim'
alias myalias='nvim ~/.bash_aliases'

# Completely remove apt package and its configuration
alias aptremove='sudo apt purge --auto-remove'

# Update all packages
alias updateall='sudo apt update && sudo apt upgrade -y'

# Directory Aliases
alias down='cd ~/Downloads'
alias docs='cd ~/Docs; clear'
alias prof='cd ~/Projects; clear'
alias dev='cd ~/Projects/Dev; clear'
alias devgit='cd ~/Projects/Dev/GitHubRepos; clear'

alias ref='cd ~/Projects/references; clear'
alias refwsl='cd ~/Projects/references/WSL; clear'
alias refubu='cd ~/Projects/references/WSL/Ubuntu; clear'

# live browser server
# alias live='http-server'

# tutorial https://www.youtube.com/watch?v=L9zfMeB2Zcc&app=desktop
alias bsync='browser-sync start --server --files "*"'
# Proxy configured to work with Django
# https://www.metaltoad.com/blog/instant-reload-django-npm-and-browsersync
alias bsync-proxy='browser-sync start --proxy 127.0.0.1:8000 --files "*"'

# Flask
alias flask='FLASK_APP=application.py FLASK_ENV=development FLASK_DEBUG=1 python -m flask run'

# Python env
alias envactivate='source env/bin/activate'
alias envactivatefish='source env/bin/activate.fish'

# Make native commands verbose
alias mv='mv -v'
alias rm='rm -v'
alias cp='cp -v'
alias mkdir='mkdir -v'
alias rmdir='rmdir -v'

# Ref: https://unix.stackexchange.com/a/125386
mkcdir () {
  mkdir -pv -- "$1" &&
    cd -P -- "$1"
  }

touched() {
  touch -- "$1" &&
    nvim -- "$1"
  }

# Move junk files to ~/.Trash
# Ref: https://stackoverflow.com/a/23659385/11850077
# When iterating through commands, DON'T for get the semi-colon before the
# closing brackets
junk() {
  for item in "$@" ; do echo "Trashing: $item" ; mv "$item" ~/.Trash/; done;
  }

# Resources
# prompt: https://stackoverflow.com/a/1885534/11850077
# params: https://stackoverflow.com/a/23659385/11850077
clearjunk() {
  JUNK_COUNTER=0
  for item in ~/.Trash/*
  do
    echo "$item"
    JUNK_COUNTER=$((JUNK_COUNTER + 1))
  done

  read -p "Proceed deleting all $JUNK_COUNTER files? (Y/y)" -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo Aborting...
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
  fi

  for item in ~/.Trash/*
  do
    rm -rf "$item"
  done

  echo "All $JUNK_COUNTER false in ~/.Trash were permanently deleted"
}

# Binaries
alias open='xdg-open'
alias ls='exa'
alias l='exa -l'
alias la='exa -la'
alias fd='fdfind'
alias python='python3'

# xclip shortcuts
# use pipe before the alias command to work with xclip
# https://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard#answer-5130969
alias c='xclip'
alias v='xclip -o'
alias cs='xclip -selection'
alias vs='xclip -o -selection'

# emacs
alias enw='emacs -nw'

# taskwarrior
alias tw='task'
alias twl='task list'

# Vimwiki
alias wiki='cd ~/Docs/wiki; nvim -c VimwikiUISelect; clear'
alias diary='cd ~/Docs/wiki; nvim -c VimwikiDiaryIndex; clear'
alias dtoday='cd ~/Docs/wiki; nvim -c "set laststatus=0 showtabline=0 colorcolumn=0|VimwikiMakeDiaryNote"; clear'
alias wikidocs='cd ~/Docs/wiki'

# Remove debug.log files recursively (will also list all debug files before removal)
alias rmdebs='find . -name "debug.log" -type f; find . -name "debug.log" -type f -delete'
# Remove .log files recursively (will also list all .log files before removal)
alias rmlogs='find . -name "*.log" -type f; find . -name "*.log" -type f -delete'

# Yank and pasting current working directory system clipboard
alias ypath='pwd | cs clipboard && clear; echo "Current path copied to clipboard"'
alias cdypath='cd "`vs clipboard`" && clear'

# Update dotfiles backup repository
DOTFILES="$HOME/Projects/.dotfiles"

dotfilesbackup() {
  cd $HOME
  DOTBACKUPDIR=$HOME/.`date -u +"%Y-%m-%dT%H:%M:%SZ"`_old_dotfiles.bak
  mkdir $DOTBACKUPDIR
  mkdir -p $DOTBACKUPDIR.config/ranger $DOTBACKUPDIR.config/zathura $DOTBACKUPDIR.vim/session
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
    $DOTBACKUPDIR
  cp -r .vim/session $DOTBACKUPDIR.vim/session
  cp .config/ranger/rc.conf $DOTBACKUPDIR/.config/ranger
  cp .config/zathura/zathurarc $DOTBACKUPDIR/.config/zathura

  if [[ "$(grep -i microsoft /proc/version)" ]]; then
    WIN_USERNAME=$(cmd.exe /c "echo %username%")
    cp -r "/mnt/c/Users/${WIN_USERNAME}/Documents/gtd/" ${DOTBACKUPDIR}
  else
    cp -r ~/.gtd/ ${DOTBACKUPDIR}
  fi

  cd -; printf '\nDOTFILES BACKUP COMPLETE...\n\n'
}

dotfilesdist() {
  # backup files first
  dotfilesbackup
  # distribute dotfiles
  cd $DOTFILES
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
    $HOME
  cp .config/ranger/rc.conf ~/.config/ranger/
  cp .config/zathura/zathurarc ~/.config/zathura/

  if [[ "$(grep -i microsoft /proc/version)" ]]; then
    WIN_USERNAME=$(cmd.exe /c "echo %username%")
    cp -r gtd /mnt/c/Users/${WIN_USERNAME}/Documents
  else
    cp -r gtd ${HOME}
  fi

  cd -; printf '\nDOTFILES DISTRIBUTION COMPLETE...\n\n'
}

dotfilesupdate() {
  cd ${DOTFILES}
  cp -r \
    ~/.bashrc ~/.bash_aliases ~/.profile \
    ~/.zshenv ~/.zshrc \
    ~/.tmux.conf \
    ~/.gitconfig \
    ~/bin \
    ~/.scimrc .
  cp ~/.vim/session .vim/session
  cp ~/.config/ranger/rc.conf .config/ranger/
  cp ~/.config/zathura/zathurarc .config/zathura/

  if [[ "$(grep -i microsoft /proc/version)" ]]; then
    WIN_USERNAME=$(cmd.exe /c "echo %username%")
    cp -r /mnt/c/Users/${WIN_USERNAME}/Documents/gtd .
  else
    cp -R ~/.gtd/.* gtd
  fi

  git add .; git status; echo 'dotfiles update complete'
}

alias dotfiles="cd ${DOTFILES}"
alias dotbackup=dotfilesbackup
alias dotdist=dotfilesdist
alias dotupdate=dotfilesupdate
alias dotcommit="cd ${DOTFILES};git commit -m"
alias dotpush="cd ${DOTFILES};git push"

# GitHub
alias gh='open https://github.com; clear'
alias repo='open `git remote -v | grep fetch | awk "{print $2}" | sed "s/git@/http:\/\//" | sed "s/com:/com\//"`| head -n1'
alias gist='open https://gist.github.com; clear'
alias insigcommit='git add  . && git commit -m "Insignificant commit" && git push'
alias commit='git commit'
alias commitall='git add . && git commit'
alias pushallrepo="cd ~/Docs/wiki; git add .; git commit; git push; cd ~/.config/nvim; pwd; git add .; git commit; git push; cd ~/Projects/references; git add .; git commit; git push; dotupdate; dotfiles; git commit; git push; echo 'Update finished'"
alias pullallrepo="cd ~/Docs/wiki; pwd; git pull; cd ~/.config/nvim; pwd; git pull; ~/Projects/references; pwd; git pull;  $DOTFILES; pwd; git pull; echo 'Syncing complete'"

# Web Servers
alias starta2='sudo service apache2 start'
alias startms='sudo service mysql start'
alias startpg='sudo service postgresql start'
alias stopa2='sudo service apache2 stop'
alias stopms='sudo service mysql stop'
alias stoppg='sudo service postgresql stop'
alias runms='sudo mysql -u root -p'
alias runpg='sudo -u postgres psql'

# Rclone
alias rcopy='rclone copy -vvP --fast-list --drive-chunk-size=32M --transfers=6 --checkers=6 --tpslimit=2'
alias rsync='rclone sync -vvP --fast-list --drive-chunk-size=32M --transfers=6 --checkers=6 --tpslimit=2'

zdev() {
  cd ~/Projects
  zip -r dev.zip Dev
}

ezdev() {
  cd ~/Projects
  zip -er dev.zip Dev
}

uzdev() {
  cd ~/Projects
  mv Dev `date "+%Y-%m-%d"`.Dev.old
  unzip dev.zip -d .
}

alias rclone-dev-gdrive="rclone copy ~/Projects/dev.zip GoogleDrive: --backup-dir GoogleDrive:$(date '+%Y-%m-%d').dev.bak -vvP --fast-list --drive-chunk-size=32M --transfers=6 --checkers=6 --tpslimit=2"
alias rclone-dev-dbox="rclone copy ~/Projects/dev.zip Dropbox: --backup-dir Dropbox:$(date '+%Y-%m-%d').dev.bak -vvP --fast-list --drive-chunk-size=32M --transfers=6 --checkers=6 --tpslimit=2"
alias rclone-gdrive-dev="rclone copy GoogleDrive:dev.zip ~/Projects --backup-dir $(date '+%Y-%m-%d').dev.bak -vvP --fast-list --drive-chunk-size=32M --transfers=6 --checkers=6 --tpslimit=2"
alias rclone-dbox-dev="rclone copy Dropbox:dev.zip ~/Projects --backup-dir $(date '+%Y-%m-%d').dev.bak -vvP --fast-list --drive-chunk-size=32M --transfers=6 --checkers=6 --tpslimit=2"

# Switch to JDK 8
openjdk8() {
  export JDK_HOME=/usr/lib/jvm/java-8-openjdk-amd64
  sudo update-alternatives --set java ${JDK_HOME}/jre/bin/java
  sudo update-alternatives --set javac ${JDK_HOME}/bin/javac
  # replace JAVA_HOME with jdk 8 path if exist, else append
  grep -q 'JAVA_HOME=' /etc/environment && \
    sudo sed -i 's,^JAVA_HOME=.*,JAVA_HOME="${JDK_HOME}/jre/",' /etc/environment || \
    echo 'JAVA_HOME="${JDK_HOME}/jre/"' | sudo tee -a /etc/environment
      # source environ
      source /etc/environment
}

# Switch to JDK 11
openjdk11() {
  export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64
  sudo update-alternatives --set java ${JDK_HOME}/bin/java
  sudo update-alternatives --set javac ${JDK_HOME}/bin/javac
  # replace JAVA_HOME with jdk 11 path if exist, else append
  grep -q 'JAVA_HOME=' /etc/environment && \
    sudo sed -i 's,^JAVA_HOME=.*,JAVA_HOME="${JDK_HOME}",' /etc/environment || \
    echo 'JAVA_HOME="${JDK_HOME}"' | sudo tee -a /etc/environment
      # source environ
    source /etc/environment
}

# Switch to JDK 13
openjdk13() {
  export JDK_HOME=/usr/lib/jvm/java-13-openjdk-amd64
  sudo update-alternatives --set java ${JDK_HOME}/bin/java
  sudo update-alternatives --set javac ${JDK_HOME}/bin/javac
  # replace JAVA_HOME with jdk 11 path if exist, else append
  grep -q 'JAVA_HOME=' /etc/environment && \
    sudo sed -i 's,^JAVA_HOME=.*,JAVA_HOME="${JDK_HOME}",' /etc/environment || \
    echo 'JAVA_HOME="${JDK_HOME}"' | sudo tee -a /etc/environment
      # source environ
      source /etc/environment
}

# gtd shell script
alias on='gtd -ts'

# tmuxinator
alias mux='tmuxinator'

# WSL aliases
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  WIN_USERNAME=$(cmd.exe /c "echo %username%")
  # Directory Aliases
  alias winhome="cd /mnt/c/Users/${WIN_USERNAME}; clear"
  alias windocs="cd /mnt/c/Users/${WIN_USERNAME}/Documents; clear"
  alias wintrade="cd /mnt/c/Users/${WIN_USERNAME}/OneDrive/Trading/Stocks; clear"
  alias windown="cd /mnt/c/Users/${WIN_USERNAME}/Downloads; clear"
  alias winbin="cd /mnt/c/bin; clear"

  # Secure files Aliases
  alias secenter="cd /mnt/c/Users/${WIN_USERNAME}; cmd.exe /C Secure.bat; cd ./Secure; clear"
  alias seclock="cd /mnt/c/Users/${WIN_USERNAME}; cmd.exe /c Secure.bat; clear"
  alias sec="cd /mnt/c/Users/${WIN_USERNAME}/Secure/; clear"
  alias secfiles="cd /mnt/c/Users/${WIN_USERNAME}/Secure; clear"
  alias secdocs="cd /mnt/c/Users/${WIN_USERNAME}/Secure/e-Files; clear"
  alias secpersonal="cd /mnt/c/Users/${WIN_USERNAME}/Secure/Personal; clear"
  alias secbrowse="cd /mnt/c/Users/${WIN_USERNAME}/Secure; explorer.exe .; cd -; clear"

  # Running Windows executable
  alias cmd='cmd.exe /C'
  alias pows='powershell.exe /C'
  alias explore='explorer.exe'

  # Windows installed browsers
  alias ffox='firefox.exe'
  alias gchrome='chrome.exe'

  # Yank currant path and convert to windows path
  # Resources:
  # Sed substitute uppercase lowercase: https://stackoverflow.com/questions/4569825/sed-one-liner-to-convert-all-uppercase-to-lowercase
  # Printf: https://linuxconfig.org/bash-printf-syntax-basics-with-examples
  # Access last returned value: https://askubuntu.com/questions/324423/how-to-access-the-last-return-value-in-bash
  winpath() {
    regex1='s/\//\\/g'
    regex2='s/~/\\\\wsl$\\Ubuntu\\home\\marklcrns/g'
    regex3='s/\\home/\\\\wsl$\\Ubuntu\\home/g'
    regex4='s/^\\mnt\\(\w)/\U\1:/g'

    output=$(pwd | sed -e "$regex1" -e "$regex2" -e "$regex3" -re "$regex4")
    printf "%s" "$output"
  }
  alias winypath="winpath | xclip -selection clipboard && printf '%s\n...win path copied' '$output'"

  # cd to Windows path string arg
  # Resources:
  # https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter
  # TODO: Fix and return string instead of "cd-ing" to the output
  cdwinpath() {
    if [[ $# -eq 0 ]] ; then
      printf "%s" "Missing Windows path string arg"
      exit 1 || return 1
    fi

    regex1='s/\\/\//g'
    regex2='s/\(\w\):/\/mnt\/\L\1/g'

    output=$(printf "%s" "$1" | sed -e "$regex1" -e "$regex2")
    cd "$output"
  }

  # Nameserver workaround for WSL2
  alias backupns='cat /etc/resolv.conf > ~/nameserver.txt'
  alias setns='echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf'
  alias restorens='cat ~/nameserver.txt | sudo tee /etc/resolv.conf'
  alias printns='cat /etc/resolv.conf'
fi

