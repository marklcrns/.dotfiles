# String ANSI colors
# Ref: https://stackoverflow.com/a/5947802/11850077
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# config files
alias vimrc='nvim ~/.vim/.vimrc'
alias tmuxconf='nvim ~/.tmux.conf'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias nvimrc='cd ~/.config/nvim'
alias myalias='nvim ~/.bash_aliases'

# Completely remove apt package and its configuration
alias aptpurge='sudo apt purge --auto-remove'
# Clean apt packages
alias aptclean='sudo apt clean; sudo apt autoclean; sudo apt autoremove'

# Update all packages
alias updateall='sudo apt update && sudo apt upgrade -y'

# Directory Aliases
alias down='cd ~/Downloads'
alias docs='cd ~/Docs'
alias drop='cd ~/Dropbox'
alias proj='cd ~/Projects'
alias dev='cd ~/Projects/Dev'
alias ref='cd ~/Projects/references'
# non-WSL aliases
if [[ -z "$(grep -i microsoft /proc/version)" ]]; then
  alias ddev='cd ~/Dropbox/Dev'
  alias drop='cd ~/Dropbox'
fi

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
    printf "${RED}Aborting...${NC}\n"
    [[ "$0" = "$BASH_SOURCE" ]] && return 1
  fi

  for item in ~/.Trash/*
  do
    rm -rf "$item"
  done

  echo "All $JUNK_COUNTER items in ~/.Trash were permanently deleted"
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
alias wiki='cd ~/Docs/wiki; nvim -c VimwikiUISelect'
alias diary='cd ~/Docs/wiki; nvim -c VimwikiDiaryIndex'
alias dtoday='cd ~/Docs/wiki; nvim -c "set laststatus=0 showtabline=0 colorcolumn=0|VimwikiMakeDiaryNote"'
alias wikidocs='cd ~/Docs/wiki'

# Remove debug.log files recursively (will also list all debug files before removal)
alias rmdebs='find . -name "debug.log" -type f; find . -name "debug.log" -type f -delete'
# Remove .log files recursively (will also list all .log files before removal)
alias rmlogs='find . -name "*.log" -type f; find . -name "*.log" -type f -delete'

# Yank and pasting current working directory system clipboard
alias ypath='pwd | cs clipboard && clear; echo "Current path copied to clipboard"'
alias cdypath='cd "`vs clipboard`" && clear'

# Update dotfiles backup repository
DOTFILES="${HOME}/Projects/.dotfiles"

dotfilesbackup() {
  cd ${HOME}
  DOTBACKUPDIR=${HOME}/.`date -u +"%Y-%m-%dT%H:%M:%S"`_old_dotfiles.bak
  mkdir ${DOTBACKUPDIR}
  mkdir ${DOTBACKUPDIR}/.config ${DOTBACKUPDIR}/.vim ${DOTBACKUPDIR}/applications
  cp -r \
    bin \
    .bashrc .bash_aliases .profile \
    .zshenv .zshrc \
    .tmux.conf \
    .gitconfig \
    .ctags \
    .ctags.d/ \
    .mutt/ \
    .rclonesyncwd/ \
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
    cp -r ~/.local/share/applications ${DOTBACKUPDIR}/applications
  else
    cp -r ~/.gtd/ ${DOTBACKUPDIR}
  fi
  cd -; printf "\n${GREEN}DOTFILES BACKUP COMPLETE...${NC}\n\n"
}

dotfilesdist() {
  # backup files first
  dotfilesbackup
  # distribute dotfiles
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
  cp .rclonesyncwd/Filters ~/.rclonesyncwd
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
    rm -rf ~/.local/share/applications/*.desktop && cp applications/* ~/.local/share/applications
  else
    cp -r .gtd ${HOME}
  fi
  cd -; printf "\n${GREEN}DOTFILES DISTRIBUTION COMPLETE...${NC}\n\n"
}

dotfilesupdate() {
  cd ${DOTFILES}
  cp -r \
    ~/.bashrc ~/.bash_aliases ~/.profile \
    ~/.zshenv ~/.zshrc \
    ~/.tmux.conf \
    ~/.gitconfig \
    ~/.scimrc \
    .
  mkdir -p .rclonesyncwd/ && cp ~/.rclonesyncwd/Filters .rclonesyncwd/
  rm -rf .vim/session; cp -r ~/.vim/session .vim
  rm -rf bin; cp -r ~/bin .
  rm -rf .config/{ranger,zathura}; cp -r \
    ~/.config/ranger/ \
    ~/.config/zathura/ \
    .config
  # Check if WSL
  if [[ "$(grep -i microsoft /proc/version)" ]]; then
    # 2>/dev/null to suppress UNC paths are not supported error
    WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
    cp -r /mnt/c/Users/${WIN_USERNAME}/Documents/.gtd .
    cp ~/.config/mimeapps.list .config
    rm -rf applications/* && cp -r ~/.local/share/applications/*.desktop applications
  else
    cp -r ~/.gtd .
  fi
  git add .; git status
  printf "${GREEN}Dotfiles update complete${NC}\n"
}

rmdotfilesbak() {
  rm -rf ~/.*dotfiles.bak
}

alias dotfiles="cd ${DOTFILES}"
alias dotbackup=dotfilesbackup
alias dotdist=dotfilesdist
alias dotupdate=dotfilesupdate
alias rmdotbak=rmdotfilesbak
alias dotadd="cd ${DOTFILES} && git add ."
alias dotcommit="cd ${DOTFILES} && git commit -m"
alias dotpush="cd ${DOTFILES} && git add . && git commit && git push"

# GitHub
alias gh='open https://github.com'
alias gist='open https://gist.github.com'
alias insigcommit='git add  . && git commit -m "Insignificant commit" && git push'
alias commit='git commit'
alias commitall='git add . && git commit'

browsegithubrepo() {
  open `git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//'`| head -n 1
}
alias openrepo=browsegithubrepo

# Ref:
# Check repo existing files changes: https://stackoverflow.com/questions/5143795/how-can-i-check-in-a-bash-script-if-my-local-git-repository-has-changes
# Check repo for all repo changes: https://stackoverflow.com/a/24775215/11850077
# Check if in git repo: https://stackoverflow.com/questions/2180270/check-if-current-directory-is-a-git-repository
export CONF_REPO_LIST="\
  ${DOTFILES}
  ${HOME}/Docs/wiki
  ${HOME}/Docs/wiki/wiki
  ${HOME}/Projects/references
  ${HOME}/.config/nvim
  ${HOME}/.tmuxinator
"

printallconfrepo() {
  echo ${CONF_REPO_LIST}
}

pushrepo() {
  # Check if in git repo
  [[ ! -d ".git" ]] && echo "$(pwd) not a git repo root." && return 1
  # Check for git repo changes
  CHANGES=$(git status --porcelain)
  # Add, commit and push if has changes
  if [[ -n ${CHANGES} ]]; then
    printf "${YELLOW}Changes detected in $(pwd). Pushing changes...${NC}\n"
    echo "2.." && sleep 1
    echo "1." && sleep 1
    git add . && git commit
    git push
    # If Authentication failed, push until successful or interrupted
    while [[ ${?} -eq 128 ]]; do
      git push
    done
  else
    echo "No changes detected in $(pwd). Skipping..."
  fi
}

pushallconfrepo() {
  CURRENT_DIR_SAVE=$(pwd)

  # Loop over all repo list excluding empty new line
  for line in $(echo ${CONF_REPO_LIST}); do
    # continue of line is empty String
    [[ -z $line ]] && continue
    # Wait until another git commit finish processing if exist
    if [[ -n $(ps -fc | grep "git commit$" | head -n 1 | awk '{print $2}') ]]; then
      wait $(ps -fc | grep "git commit$" | head -n 1 | awk '{print $2}')
    fi
    # Go to a repo repo then push
    cd $line && pushrepo
  done

  printf "${GREEN}All repo push complete!${NC}\n"
  cd ${CURRENT_DIR_SAVE}
}


pullrepo() {
  # Check if in git repo
  [[ ! -d ".git" ]] && echo "$(pwd) not a git repo. root" && return 1
  # Check for git repo changes
  CHANGES=$(git status --porcelain --untracked-files=no)
  # Pull if no changes
  if [[ -n ${CHANGES} ]]; then
    printf "${RED}Changes detected in existing $(pwd) files. Skipping...${NC}\n"
  else
    echo "$(pwd). Pulling from remote"
    git pull
    # If Authentication failed, push until successful or interrupted
    while [[ ${?} -eq 128 ]]; do
      git push
    done
  fi
}

pullallconfrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  # Loop over all repo list excluding empty new line
  while read line && [[ -n $line ]]; do
    cd $line && pullrepo
  done <<< ${CONF_REPO_LIST}

  echo 'All remote pull complete!'
  cd ${CURRENT_DIR_SAVE}
}

forcepullrepo() {
  # Check if in git repo
  [[ ! -d ".git" ]] && echo "$(pwd) not a git repo. root" && return 1
  # Check for git repo changes
  CHANGES=$(git status --porcelain --untracked-files=no)
  # Pull if no changes
  if [[ -n ${CHANGES} ]]; then
    printf "${YELLOW}Changes detected in existing $(pwd) files. Hard resetting repo...${NC}\n"
    git reset --hard HEAD^
    git pull
  else
    echo "$(pwd). Pulling from remote"
    git pull
    # If Authentication failed, push until successful or interrupted
    while [[ ${?} -eq 128 ]]; do
      git push
    done
  fi
}

forcepullallconfrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  # Loop over all repo list excluding empty new line
  while read line && [[ -n $line ]]; do
    cd $line && forcepullrepo
  done <<< ${CONF_REPO_LIST}

  printf "${GREEN}All remote pull complete!${NC}\n"
  cd ${CURRENT_DIR_SAVE}
}

statusrepo() {
  # Check if in git repo
  [[ ! -d ".git" ]] && echo "$(pwd) not a git repo root." && return
  # Check for git repo changes
  CHANGES=$(git status --porcelain)
  # Git status if has changes
  if [[ -n ${CHANGES} ]]; then
    printf "${YELLOW}Changes detected in $(pwd).${NC}\n"
    git status
  else
    echo "No changes detected in $(pwd)."
  fi
}

statusallconfrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  while read line && [[ -n $line ]]; do
    cd $line && statusrepo
  done <<< ${CONF_REPO_LIST}

  printf "${GREEN}All repo status complete!${NC}\n"
  cd ${CURRENT_DIR_SAVE}
}

alias gprintconf=printallconfrepo
alias gpullconf=pullallconfrepo
alias gfpullconf=forcepullallconfrepo
alias gpushconf=pushallconfrepo
alias gstatusconf=statusallconfrepo

# Ref:
# Find: https://stackoverflow.com/a/15736463
# Loops: https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# Loop over lines in a variable: https://superuser.com/a/284226
# Wait: https://stackoverflow.com/questions/49823080/use-bash-wait-in-for-loop
# PID: https://www.cyberciti.biz/faq/linux-find-process-name/
DEV_REPO_DIR="${HOME}/Projects/Dev"
DEV_REPO_LIST_NAME="dev_repos_list.txt"
DEV_REPO_LIST_PATH=${DOTFILES}/${DEV_REPO_LIST_NAME}

createalldevrepolist() {
  CURRENT_DIR_SAVE=$(pwd)
  # Get all dev repo and store in $DEV_REPO_LIST_PATH
  # Convert home path to ~
  regex1="s,.*(/Projects/.*$),~\1,"
  find ${DEV_REPO_DIR} -name ".git" -not -path "*/forked-repos/*" | \
    sed -r "${regex1}" > ${DEV_REPO_LIST_PATH}

  [[ -f ${DEV_REPO_LIST_PATH} ]] && \
    echo "Created ${DEV_REPO_LIST_PATH}" && cat ${DEV_REPO_LIST_PATH}

  cd ${CURRENT_DIR_SAVE}
}

printalldevrepo() {
  cat $DEV_REPO_LIST_PATH
}

# Convert dev repo list line to path absolute path
convertdevlinetopath() {
  local arg1=$1
  # Truncate .git from path
  regex1="s,(.*)/\.git,\1,"
  # Replace ~ with absolute $HOME path
  regex2="s,~(.*),${HOME}\1,"
  # Get repo directory
  retval=`echo $arg1 | sed -r "${regex1};${regex2}"`
}

clonealldevrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  GIT_PROFILE_LINK="https://github.com/marklcrns/"
  if [[ ! -f  ${DEV_REPO_LIST_PATH} ]]; then
    printf "${RED}${DEV_REPO_LIST_NAME} in ${DOTFILES} does not exist${NC}\n"
    return 1
  elif [[ ! -s "${DEV_REPO_LIST_PATH}" ]]; then
    printf "${YELLOW}${DEV_REPO_LIST_NAME} in ${DOTFILES} is empty${NC}\n"
    return 1
  fi

  echo "Validating Dev repos..."
  while read line && [[ -n $line ]]; do
    # Convert line to abs PATH
    convertdevlinetopath $line
    REPO_DIR=${retval}
    # Clone repo if repo dir and .git not exist
    if [[ ! -d ${REPO_DIR} ]]; then
      mkdir -p ${REPO_DIR}
      git clone ${GIT_PROFILE_LINK}/`basename ${REPO_DIR}` ${REPO_DIR}
      # If Authentication failed, clone until successful or interrupted
      while [[ ${?} -eq 128 ]]; do
        git clone ${GIT_PROFILE_LINK}/`basename ${REPO_DIR}` ${REPO_DIR}
      done
    elif [[ ! -d "${REPO_DIR}/.git" ]]; then
      rm -rf ${REPO_DIR} && \
        git clone ${GIT_PROFILE_LINK}/`basename ${REPO_DIR}` ${REPO_DIR}
      # If Authentication failed, clone until successful or interrupted
      while [[ ${?} -eq 128 ]]; do
        git clone ${GIT_PROFILE_LINK}/`basename ${REPO_DIR}` ${REPO_DIR}
      done
    fi
  done < ${DEV_REPO_LIST_PATH}

  printf "${GREEN}Dev repo cloning complete!${NC}\n"
  cd ${CURRENT_DIR_SAVE}
}

pushalldevrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  # return if no Dev repos
  [[ ! -d  ${DEV_REPO_LIST_PATH} ]] && [[ -z $(cat ${DEV_REPO_LIST_PATH}) ]] && \
    echo "No Dev git repository in ${DEV_REPO_DIR}" && return 1
  # Loop variation 1: Works well with `wait` command
  for line in $(cat ${DEV_REPO_LIST_PATH}); do
    # continue of line is empty String
    [[ -z $line ]] && continue
    # Wait until another git commit finish processing if exist
    if [[ -n $(ps -fc | grep "git commit$" | head -n 1 | awk '{print $2}') ]]; then
      wait $(ps -fc | grep "git commit$" | head -n 1 | awk '{print $2}')
    fi
    # Convert line to abs PATH
    convertdevlinetopath $line
    REPO_DIR=${retval}
    # Go to a Dev repo then push
    cd ${REPO_DIR}
    pushrepo
  done
  cd ${CURRENT_DIR_SAVE}
}

pullalldevrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  # return if no Dev repos
  [[ ! -d  ${DEV_REPO_LIST_PATH} ]] && [[ -z $(cat ${DEV_REPO_LIST_PATH}) ]] && \
    echo "No Dev git repository in ${DEV_REPO_DIR}" && return 1
  # Loop variation 2: Ensures no leadiing line
  while read line && [[ -n $line ]]; do
    # Convert line to abs PATH
    convertdevlinetopath $line
    REPO_DIR=${retval}
    # cd into Dev repo and pull
    cd ${REPO_DIR}
    pullrepo
  done < ${DEV_REPO_LIST_PATH}
  cd ${CURRENT_DIR_SAVE}
}

forcepullalldevrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  cd ~
  # return if no Dev repos
  [[ ! -d  ${DEV_REPO_LIST_PATH} ]] && [[ -z $(cat ${DEV_REPO_LIST_PATH}) ]] && \
    echo "No Dev git repository in ${DEV_REPO_DIR}" && return 1
  # Loop variation 2: Ensures no leadiing line
  while read line && [[ -n $line ]]; do
    # Convert line to abs PATH
    convertdevlinetopath $line
    REPO_DIR=${retval}
    # cd into Dev repo and force pull
    cd ${REPO_DIR}
    forcepullrepo
  done < ${DEV_REPO_LIST_PATH}
  cd ${CURRENT_DIR_SAVE}
}

statusalldevrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  # return if no Dev repos
  [[ ! -d  ${DEV_REPO_LIST_PATH} ]] && [[ -z $(cat ${DEV_REPO_LIST_PATH}) ]] && \
    echo "No Dev git repository in ${DEV_REPO_DIR}" && return 1
  # Loop variation 2: Ensures no leadiing line
  while read line && [[ -n $line ]]; do
    # Convert line to abs PATH
    convertdevlinetopath $line
    REPO_DIR=${retval}
    # cd into Dev repo and pull
    cd ${REPO_DIR}
    statusrepo
  done < ${DEV_REPO_LIST_PATH}
  cd ${CURRENT_DIR_SAVE}
}

alias gpushdev=pushalldevrepo
alias gpulldev=pullalldevrepo
alias gfpulldev=forcepullalldevrepo
alias gstatusdev=statusalldevrepo
alias grounddev=roundalldevrepo
alias gprintdev=printalldevrepo
alias gcreatedev=createalldevrepolist
alias gclonedev=clonealldevrepo

# Ref: https://stackoverflow.com/a/3278427
checkremotechanges() {
  UPSTREAM=${1:-'@{u}'}
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse "$UPSTREAM")
  BASE=$(git merge-base @ "$UPSTREAM")

  if [[ $REMOTE = $BASE ]]; then
    echo "$(pwd) Repo need to push"
    pushrepo
  elif [[ $LOCAL = $BASE ]]; then
    echo "$(pwd) Repo need to pull"
    pullrepo
  elif [[ $LOCAL = $REMOTE ]]; then
    echo "$(pwd) Up-to-date"
  else
    printf "${RED} $(pwd) Repo diverges${NC}\n"
  fi
}

# TODO:
syncallrepo() {
  CURRENT_DIR_SAVE=$(pwd)
  cd ~/Docs/wiki && checkremotechanges
  cd ~/Docs/wiki/wiki && checkremotechanges
  cd ~/.config/nvim && checkremotechanges
  cd ~/Projects/references && checkremotechanges
  cd ~/.tmuxinator && checkremotechanges
  dotupdate && \
    CHANGE_STATUS=$(checkremotechanges) && echo ${CHANGE_STATUS} && \
    [[ "${CHANGE_STATUS}" == *"Repo need to pull"* ]] && dotdist

  printf "${GREEN}All repo synced${NC}\n"
  cd ${CURRENT_DIR_SAVE}
}

# Web Servers
alias starta2='sudo service apache2 start'
alias startms='sudo service mysql start'
alias startpg='sudo service postgresql start'
alias stopa2='sudo service apache2 stop'
alias stopms='sudo service mysql stop'
alias stoppg='sudo service postgresql stop'
alias runms='sudo mysql -u root -p'
alias runpg='sudo -u postgres psql'

# Rclonesynv-V2
REMOTE="GoogleDrive:Dev"
DEV="~/Projects/Dev"
# Ref: https://forum.rclone.org/t/how-to-speed-up-google-drive-sync/8444/9
RCLONE_ARGS="--copy-links --fast-list --transfers=40 --checkers=40 --tpslimit=10 --drive-chunk-size=1M"

# DEV might overwrite REMOTE
alias rcsrmtdev="rclonesync.py --verbose --remove-empty-directories --filters-file ~/.rclonesyncwd/Filters ${REMOTE} ${DEV} --rclone-args ${RCLONE_ARGS}"
alias rcsrmtdev-first="rclonesync.py --verbose --first-sync --filters-file ~/.rclonesyncwd/Filters ${REMOTE} ${DEV} --rclone-args ${RCLONE_ARGS}"
alias rcsrmtdev-dry="rclonesync.py --verbose --remove-empty-directories --dry-run --filters-file ~/.rclonesyncwd/Filters ${REMOTE} ${DEV} --rclone-args ${RCLONE_ARGS}"
alias rcsrmtdev-first-dry="rclonesync.py --verbose --dry-run --first-sync --filters-file ~/.rclonesyncwd/Filters ${REMOTE} ${DEV} --rclone-args ${RCLONE_ARGS}"

# REMOTE might overwrite DEV
alias rcsdevrmt="rclonesync.py --verbose --remove-empty-directories --filters-file ~/.rclonesyncwd/Filters ${DEV} ${REMOTE} --rclone-args ${RCLONE_ARGS}"
alias rcsdevrmt-first="rclonesync.py --verbose --first-sync --filters-file ~/.rclonesyncwd/Filters ${DEV} ${REMOTE} --rclone-args ${RCLONE_ARGS}"
alias rcsdevrmt-dry="rclonesync.py --verbose --remove-empty-directories --dry-run --filters-file ~/.rclonesyncwd/Filters ${DEV} ${REMOTE} --rclone-args ${RCLONE_ARGS}"
alias rcsdevrmt-first-dry="rclonesync.py --verbose --first-sync --dry-run --filters-file ~/.rclonesyncwd/Filters ${DEV} ${REMOTE} --rclone-args ${RCLONE_ARGS}"
alias rcs="rclonesync.py --verbose --filters-file ~/.rclonesyncwd/Filters"

# Rclone
alias rcopy="rclone copy -vvP ${RCLONE_ARGS}"
alias rsync="rclone sync -vvP ${RCLONE_ARGS}"
alias rcdevrmt="rclone sync ~/Projects/Dev GoogleDrive:Dev --backup-dir GoogleDrive:$(date '+%Y-%m-%d').Dev.bak -vvP ${RCLONE_ARGS}"
alias rcrmtdev="rclone sync GoogleDrive:Dev ~/Projects/Dev --backup-dir $(date '+%Y-%m-%d').Dev.bak -vvP ${RCLONE_ARGS}"


# Switch JDK version
setjavahome() {
  sudo update-alternatives --set java "${JDK_HOME}/jre/bin/java"
  sudo update-alternatives --set javac "${JDK_HOME}/bin/javac"
  # replace JAVA_HOME with $JDK_HOME path if exist, else append
  grep -q 'JAVA_HOME=' /etc/environment && \
    sudo sed -i "s,^JAVA_HOME=.*,JAVA_HOME=${JDK_HOME}/jre/," /etc/environment || \
    echo "JAVA_HOME=${JDK_HOME}/jre/" | sudo tee -a /etc/environment
  # source environ
  source /etc/environment
}
alias openjdk8="export JDK_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && setjavahome"
alias openjdk11="export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64 && setjavahome"
alias openjdk13="export JDK_HOME=/usr/lib/jvm/java-13-openjdk-amd64 && setjavahome"

# gtd shell script
alias on="gtd -ts"

# tmuxinator
alias mux="tmuxinator"

# Remove zone modifiers and attributes
alias rmzone='find . -name "*Zone.*" && find . -name "*Zone.*" -delete'
alias rmdattrs='find . -name "*dropbox.attrs" && find . -name "*dropbox.attrs" -delete'
alias rmallmodattr="rmzone && rmdattr"

# WSL aliases
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  # 2>/dev/null to suppress UNC paths are not supported error
  WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
  # Directory Aliases
  alias winhome="cd /mnt/c/Users/${WIN_USERNAME}"
  alias windocs="cd /mnt/c/Users/${WIN_USERNAME}/Documents"
  alias wintrade="cd /mnt/c/Users/${WIN_USERNAME}/OneDrive/Trading/Stocks"
  alias windown="cd /mnt/c/Users/${WIN_USERNAME}/Downloads"
  alias windrop="cd /mnt/c/Users/${WIN_USERNAME}/Dropbox"
  alias windev="cd /mnt/c/Users/${WIN_USERNAME}/Dropbox/Dev"
  alias winbin="cd /mnt/c/bin"

  # Secure files Aliases
  alias secenter="cd /mnt/c/Users/${WIN_USERNAME}; cmd.exe /C Secure.bat; cd ./Secure"
  alias seclock="cd /mnt/c/Users/${WIN_USERNAME}; cmd.exe /c Secure.bat"
  alias sec="cd /mnt/c/Users/${WIN_USERNAME}/Secure"
  alias secfiles="cd /mnt/c/Users/${WIN_USERNAME}/Secure"
  alias secdocs="cd /mnt/c/Users/${WIN_USERNAME}/Secure/e-Files"
  alias secpersonal="cd /mnt/c/Users/${WIN_USERNAME}/Secure/Personal"
  alias secbrowse="cd /mnt/c/Users/${WIN_USERNAME}/Secure; explorer.exe .; cd -"

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
  cdwinpath() {
    if [[ $# -eq 0 ]] ; then
      printf "%s" "Missing Windows path string arg"
    else
      regex1='s/\\/\//g'
      regex2='s/\(\w\):/\/mnt\/\L\1/g'

      output=$(printf "%s" "$1" | sed -e "$regex1" -e "$regex2")
      cd "$output"
    fi
  }

  # Nameserver workaround for WSL2
  alias backupns='cat /etc/resolv.conf > ~/nameserver.txt'
  alias setns='echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf'
  alias restorens='cat ~/nameserver.txt | sudo tee /etc/resolv.conf'
  alias printns='cat /etc/resolv.conf'
fi

