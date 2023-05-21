# String ANSI colors
# Resources: https://stackoverflow.com/a/5947802/11850077
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

alias reveille='gpullconf;pullalldevrepo;dotd -dV'
alias taps='dotu -dV;gpushconf;pushalldevrepo'

# Config files
alias nvimc='nvim -u ~/.config/nvim/init_mininal.vim'
alias vimrc='nvim ~/.vim/.vimrc'
alias tmuxconf='nvim ~/.tmux.conf'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias nvimrc='cd ~/.config/nvim'
alias myalias='nvim ~/.bash_aliases'

# Apt package management
alias aptpurge='sudo apt purge --auto-remove'
alias aptclean='sudo apt clean; sudo apt autoclean; sudo apt autoremove'
alias aptupdate='sudo apt update --fix-missing && sudo apt upgrade -y'
alias aptinstall='sudo apt install -y'

# Directory Aliases
alias down='cd ~/Downloads'
alias docs='cd ~/Documents'
alias dev='cd ~/Documents/dev'
alias drop='cd ~/Dropbox'
alias dropd='cd ~/Dropbox/dev'
alias dev='cd ~/Documents/dev'

# tutorial https://www.youtube.com/watch?v=L9zfMeB2Zcc&app=desktop
alias bsync='browser-sync start --server --files "**/*"'
# Proxy configured to work with Django
# https://www.metaltoad.com/blog/instant-reload-django-npm-and-browsersync
alias bsync-proxy='browser-sync start --proxy 127.0.0.1:8000 --files "*"'

# Flask
alias flask='FLASK_APP=application.py FLASK_ENV=development FLASK_DEBUG=1 python -m flask run'

# Python
alias envactivate='source env/bin/activate'
alias pyinit='python3 -m venv env && envactivate'
alias pipgenreq='pip freeze > requirements.txt'
alias pipinstreq='pip install -r requirements.txt'

# Make native commands verbose
alias mv='mv -v'
alias rm='rm -v'
alias cp='cp -v'
alias mkdir='mkdir -v'
alias rmdir='rmdir -v'
alias clear='clear -x' # keep buffer when clearing

# Resources: https://unix.stackexchange.com/a/125386
mkcd() {
	mkdir -pv -- "$1" && cd -P -- "$1"
}

touched() {
	touch -- "$1" && nvim -- "$1"
}

# Binaries
if command -v xdg-open &>/dev/null; then
	alias open='xdg-open'
fi
if command -v exa &>/dev/null; then
	alias ls='exa'
	alias la='exa -la'
fi
if command -v fdfind &>/dev/null; then
	alias fd='fdfind'
fi

# xclip shortcuts
# use pipe before the alias command to work with xclip
# https://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard#answer-5130969
alias c='xclip'
alias v='xclip -o'
alias cs='xclip -selection'
alias vs='xclip -o -selection'

# alias for opening nvim on fzf selection
alias nvimfzf='nvim "$(fzf)"'
alias vimfzf='vim "$(fzf)"'

# leetcode-cli
alias lc='leetcode'
alias lcgen='leetcode show -gxe -l java'
alias lcse='leetcode show -gxe -q eL -l java'
alias lcsE='leetcode show -gxe -q EL -l java'
alias lcsm='leetcode show -gxe -q mL -l java'
alias lcsM='leetcode show -gxe -q ML -l java'
alias lcsh='leetcode show -gxe -q hL -l java'
alias lcsH='leetcode show -gxe -q HL -l java'

# Taskwarrior
alias tw='task'
alias twl='task list'

# Find and replace
alias fnr=find_and_replace

# Vimwiki
alias wiki='nvim -c VimwikiUISelect'
alias diary='nvim -c VimwikiDiaryIndex'
alias dtoday='nvim -c "call DToday()"'
alias wikidocs="cd ${WIKI_HOME}"

# Remove debug.log files recursively (will also list all debug files before removal)
alias rmdebs='find . -name "debug.log" -type f; find . -name "debug.log" -type f -delete'
# Remove .log files recursively (will also list all .log files before removal)
alias rmlogs='find . -name "*.log" -type f; find . -name "*.log" -type f -delete'

# Use https://github.com/marklcrns/scripts/blob/master/tools/compressors/shrinkpdf.sh
alias spdf="shrinkpdf"

shrinkpdf() {
	if [[ -n "${1}" ]]; then
		local dir="${1}"
		shift 1
	else
		echo "No directory provided!"
		return 1
	fi

	if [[ -n "${2}" ]]; then
		local name="${2}"
		shift 1
	else
		local name="*.pdf"
	fi

	local flags=("${@}")
	find ${dir} ${flags[@]} -name "${name}" -type f -exec shrinkpdf.sh {} {}.comp \; -exec mv {}.comp {} \;
}

# Update dotfiles backup repository
DOTFILES="${HOME}/.dotfiles"

dotfilespush() {
	CURRENT_DIR_SAVE=$(pwd)
	cd ${DOTFILES}
	git add . && git commit
	git push --all
	cd ${CURRENT_DIR_SAVE}
}

alias dotf="cd ${DOTFILES}"
alias dotb="dotbackup -aDvy"
alias dotd="dotdist -bDv"
alias dotu="dotupdate -Dv"
alias dotcb="dotclearbak -Dvy"
alias dota="cd ${DOTFILES} && git add ."
alias dotcm="cd ${DOTFILES} && git commit"
alias dotcma="cd ${DOTFILES} && git add . && git commit"
alias dotp=dotfilespush

# GitHub
alias lfsstore="git-lfs-store"
alias gh='open https://github.com'
alias gist='open https://gist.github.com'
alias insigcommit='git add . && git commit -m "Insignificant commit" && git push'
alias commit='git commit'
alias commitall='git add . && git commit'
# Ref: https://nickymeuleman.netlify.app/blog/delete-git-branches
alias gdub='git fetch --prune && git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'

# Recursively store files over the given size in current dir into git-lfs
# Default size = 100 (MiB)
git-lfs-store() {
	local size=${1:-100}
	if ! [[ $size =~ '^[0-9]+$' ]]; then
		echo "ERROR: Invalid size" >&2
		exit 1
	fi

	find * -type f -size +${size}M -exec git lfs track --filename '{}' +
}

browsegithubrepo() {
	open $(git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//') | head -n 1 &
}
alias openrepo=browsegithubrepo

# Resources:
# Check repo existing files changes: https://stackoverflow.com/questions/5143795/how-can-i-check-in-a-bash-script-if-my-local-git-repository-has-changes
# Check repo for all repo changes: https://stackoverflow.com/a/24775215/11850077
# Check if in git repo: https://stackoverflow.com/questions/2180270/check-if-current-directory-is-a-git-repository
export CONF_REPO_LIST="\
  ${DOTFILES}
  ${HOME}/.config/nvim/snippets/
  ${HOME}/.config/nvim/
  ${HOME}/.ez-install.d/
  ${HOME}/.task/
  ${HOME}/.timewarrior/
  ${HOME}/.tmuxinator/
  ${HOME}/Documents/my-wiki/
  ${HOME}/Documents/my-zettelkasten/
  ${HOME}/scripts/
  ${HOME}/texmf/
"

printallconfrepo() {
	echo ${CONF_REPO_LIST}
}

# NOTE: Aliases with '\n' must be string literal, while double quoting all
# in-line variable references  to read all string characters, otherwise will be
# truncated at the '\n'.
alias gprintconf='echo "${CONF_REPO_LIST}"'
alias gpullconf='gbulk -PV -l "${CONF_REPO_LIST}"'
alias gfpullconf='gbulk -fPV -l "${CONF_REPO_LIST}"'
alias gpushconf='gbulk -pV -l "${CONF_REPO_LIST}"'
alias gfpushconf='gbulk -fpV -l "${CONF_REPO_LIST}"'
alias gstatusconf='gbulk -sV -l "${CONF_REPO_LIST}"'

pushrepo() {
	# Check if in git repo
	[[ ! -d ".git" ]] && echo "$(pwd) not a git repo root." && return 1
	# Check for git repo changes
	CHANGES=$(git status --porcelain)
	BRANCH_NAME=$(git symbolic-ref --short -q HEAD)
	REMOTE_HEAD=$(git log --decorate --oneline | grep "origin/${BRANCH_NAME}")
	# Add, commit and push if has changes
	if [[ -n ${CHANGES} ]]; then
		printf "${YELLOW}Changes detected in $(pwd). Pushing changes...${NC}\n"
		echo "2.." && sleep .5
		echo "1." && sleep .5
		git add . && git commit
		git push --all
		# If Authentication failed, push until successful or interrupted
		while [[ ${?} -eq 128 ]]; do
			git push --all
		done
	elif [[ ! "${REMOTE_HEAD}" == *"HEAD ->"* ]]; then
		# if HEAD ahead of remote or has something to push. push repo.
		git push --all
		while [[ ${?} -eq 128 ]]; do
			git push --all
		done
	else
		echo "No changes detected in $(pwd). Skipping..."
	fi
}

pullrepo() {
	# Check if in git repo
	[[ ! -d ".git" ]] && echo "$(pwd) not a git repo. root" && return 1
	# Check for git repo changes
	CHANGES=$(git status --porcelain --untracked-files=no)
	# Pull if no changes
	if [[ -n ${CHANGES} ]]; then
		printf "${RED}Changes detected in $(pwd) files. Skipping...${NC}\n"
	else
		echo "$(pwd). Pulling from remote"
		git pull --all
		# If Authentication failed, push until successful or interrupted
		while [[ ${?} -eq 128 ]]; do
			git push --all
		done
	fi
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

# Resources:
# Find: https://stackoverflow.com/a/15736463
# Loops: https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# Loop over lines in a variable: https://superuser.com/a/284226
# Wait: https://stackoverflow.com/questions/49823080/use-bash-wait-in-for-loop
# PID: https://www.cyberciti.biz/faq/linux-find-process-name/
DEV_REPO_DIR="${HOME}/Documents/dev"
DEV_REPO_LIST_NAME="devrepolist.txt"
DEV_REPO_LIST_PATH=${DOTFILES}/${DEV_REPO_LIST_NAME}
DEV_PULL_LIST_FILE="devpulllist.txt"
DEV_PUSH_LIST_FILE="devpushlist.txt"
DEV_PULL_LIST_PATH=${DOTFILES}/${DEV_PULL_LIST_FILE}
DEV_PUSH_LIST_PATH=${DOTFILES}/${DEV_PUSH_LIST_FILE}

createalldevrepolists() {
	CURRENT_DIR_SAVE=$(pwd)
	# Get all dev repo and store in $DEV_REPO_LIST_PATH
	# Convert home path to ~ and truncate .git
	regex1="s,.*(/Documents/dev/.*)/.git$,~\1,"

	# Create devpulllist.txt
	find ${DEV_REPO_DIR} -name ".git" |
		sed -r "${regex1}" >${DEV_PULL_LIST_PATH}

	# Create devpushlist.txt
	find ${DEV_REPO_DIR} -name ".git" -not -path "*/cloned-repos/*" |
		sed -r "${regex1}" >${DEV_PUSH_LIST_PATH}

	# Append repo links in pull list
	for line in $(cat ${DEV_PULL_LIST_PATH}); do
		GIT_REPO_PATH=$line
		# cd into repo
		ABS_PATH=$(echo ${GIT_REPO_PATH} | sed -r "s,~,${HOME},")
		cd ${ABS_PATH}
		# Get repo github link
		GIT_REPO_LINK="$(git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//')"
		# Append repo absolute path its github link in dev_repo_list.txt
		sed -i "s|^${GIT_REPO_PATH}$|${GIT_REPO_PATH};${GIT_REPO_LINK}|" ${DEV_PULL_LIST_PATH}
	done

	# Append repo links in push list
	for line in $(cat ${DEV_PUSH_LIST_PATH}); do
		GIT_REPO_PATH=$line
		# cd into repo
		ABS_PATH=$(echo ${GIT_REPO_PATH} | sed -r "s,~,${HOME},")
		cd ${ABS_PATH}
		# Get repo github link
		GIT_REPO_LINK="$(git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//')"
		# Append repo absolute path its github link in dev_repo_list.txt
		sed -i "s|^${GIT_REPO_PATH}$|${GIT_REPO_PATH};${GIT_REPO_LINK}|" ${DEV_PUSH_LIST_PATH}
	done

	[[ -f ${DEV_PULL_LIST_PATH} ]] &&
		echo "Created ${DEV_PULL_LIST_PATH}" && cat ${DEV_PULL_LIST_PATH}

	[[ -f ${DEV_PUSH_LIST_PATH} ]] &&
		echo "Created ${DEV_PUSH_LIST_PATH}" && cat ${DEV_PUSH_LIST_PATH}

	cd ${CURRENT_DIR_SAVE}
}

printdevrepolists() {
	echo $DEV_PULL_LIST_PATH
	cat $DEV_PULL_LIST_PATH
	echo
	echo $DEV_PUSH_LIST_PATH
	cat $DEV_PUSH_LIST_PATH
}

printalldevrepo() {
	# Print all current dev pull repos
	PULL_DEV_REPO="$(find ${DEV_REPO_DIR} -name ".git")"
	# Truncate .git from output
	regex1="s,(.*)/.git$,\1,"
	PULL_DEV_REPO="$(echo ${PULL_DEV_REPO} | sed -r ${regex1})"
	echo ${PULL_DEV_REPO}

	# Print all current dev push repos
	PUSH_DEV_REPO="$(find ${DEV_REPO_DIR} -name ".git" -not -path "*/cloned-repos/*")"
	# Truncate .git from output
	regex1="s,(.*)/.git$,\1,"
	PUSH_DEV_REPO="$(echo ${PUSH_DEV_REPO} | sed -r ${regex1})"
	echo ${PUSH_DEV_REPO}
}

# Resources:
# Loop over delimited string: https://stackoverflow.com/a/27704337
# Zsh prompt: https://superuser.com/a/556006
# Bash prompt: https://stackoverflow.com/a/1885534
# Delete lines with forward slashes in file: https://stackoverflow.com/a/25173311
# TODO: un-DRY code
checkalldevrepos() {
	CURRENT_DIR_SAVE=$(pwd)
	# Cat dev repo lists content into a variable
	PULL_DEV_LIST="$(cat ${DEV_PULL_LIST_PATH})" || return 1
	PUSH_DEV_LIST="$(cat ${DEV_PUSH_LIST_PATH})" || return 1
	# Find all dev repos and strip .git and home path substring and append ~/
	regex1="s,.*(/Documents/dev/.*)/.git$,~\1,"
	PULL_DEV_REPO="$(find ${DEV_REPO_DIR} -name ".git" | sed -r "${regex1}")"
	PUSH_DEV_REPO="$(find ${DEV_REPO_DIR} -name ".git" -not -path "*/cloned-repos/*" | sed -r "${regex1}")"

	echo "Checking untracked dev PULL repos..."
	for repo in $(echo ${PULL_DEV_REPO} | sed "s/\n/ /g"); do
		ABS_REPO_PATH=$(echo ${repo} | sed -r "s,~,${HOME},")
		# check if repo in dev list
		if [[ ! ${PULL_DEV_LIST} == *"${repo}"* ]]; then
			printf "    ${RED}${repo} Untracked from dev list${NC}\n"
			# Prompt for action
			echo "Do you want to add ${repo} in ${DEV_PULL_LIST_FILE}? (Y/y)"
			echo "or type (delete) to permanently delete repo..."
			read REPLY
			if [[ "$REPLY" =~ ^[Yy]$ ]]; then
				# Get absolute path and cd in
				cd ${ABS_REPO_PATH}
				# Get repo github link
				GIT_REPO_LINK="$(git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//')"
				# Append repo absolute path and link in devpushlist.txt
				echo "${repo};${GIT_REPO_LINK}" >>${DEV_PULL_LIST_PATH}
				printf "${GREEN}${ABS_REPO_PATH} Added${NC}\n\n"
			elif [[ "$REPLY" =~ ^(Delete|delete|DELETE) ]]; then
				rm -rf ${ABS_REPO_PATH}
				printf "${RED}${ABS_REPO_PATH} Deleted${NC}\n\n"
			fi
		else
			echo "${repo}"
		fi
	done

	echo "Checking untracked dev PUSH repos..."
	for repo in $(echo ${PUSH_DEV_REPO} | sed "s/\n/ /g"); do
		ABS_REPO_PATH=$(echo ${repo} | sed -r "s,~,${HOME},")
		# check if repo in dev list
		if [[ ! ${PUSH_DEV_LIST} == *"${repo}"* ]]; then
			printf "    ${RED}${repo} Untracked from dev list${NC}\n"
			# Prompt for action
			echo "Do you want to add ${repo} in ${DEV_PUSH_LIST_FILE}? (Y/y)"
			echo "or type (delete) to permanently delete repo..."
			read REPLY
			if [[ "$REPLY" =~ ^[Yy]$ ]]; then
				# Get absolute path and cd in
				cd ${ABS_REPO_PATH}
				# Get repo github link
				GIT_REPO_LINK="$(git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//')"
				# Append repo absolute path and link in devpushlist.txt
				echo "${repo};${GIT_REPO_LINK}" >>${DEV_PUSH_LIST_PATH}
				printf "${GREEN}${ABS_REPO_PATH} Added${NC}\n\n"
			elif [[ "$REPLY" =~ ^(Delete|delete|DELETE) ]]; then
				rm -rf ${ABS_REPO_PATH}
				printf "${RED}${ABS_REPO_PATH} Deleted${NC}\n\n"
			fi
		else
			echo "${repo}"
		fi
	done

	echo
	# Re-cat dev pull list for changes
	PULL_DEV_LIST="$(cat ${DEV_PULL_LIST_PATH})"
	# Re-cat dev push list for changes
	PUSH_DEV_LIST="$(cat ${DEV_PUSH_LIST_PATH})"

	echo "Checking uncloned repo from dev PULL list..."
	for line in $(echo ${PULL_DEV_LIST} | sed "s/\n/ /g"); do
		# Get repo path from line
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		GIT_LINK="$(cut -d';' -f2 <<<"$line")"
		# Check if repo path in dev repos
		if [[ ! ${PULL_DEV_REPO} == *"${REPO_PATH}"* ]]; then
			printf "    ${YELLOW}${REPO_PATH} Missing${NC}\n"
			# Prompt for action
			echo "Do you want to clone ${GIT_LINK}? (Y/y)"
			echo "or type (remove) to remove repo from dev list..."
			read REPLY
			if [[ "$REPLY" =~ ^[Yy]$ ]]; then
				mkdir -p ${ABS_REPO_PATH}
				git clone ${GIT_LINK} ${ABS_REPO_PATH} &&
					printf "${GREEN}${GIT_LINK} Cloned${NC}\n\n"

			elif [[ "$REPLY" =~ ^(Remove|remove|REMOVE) ]]; then
				sed -i "\|${line}|d" ${DEV_PULL_LIST_PATH}
				printf "${RED}${REPO_PATH} Removed from dev list${NC}\n\n"
			fi
		else
			echo "${REPO_PATH}"
		fi
	done

	echo "Checking uncloned repo from dev PUSH list..."
	for line in $(echo ${PUSH_DEV_LIST} | sed "s/\n/ /g"); do
		# Get repo path from line
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		GIT_LINK="$(cut -d';' -f2 <<<"$line")"
		# Check if repo path in dev repos
		if [[ ! ${PUSH_DEV_REPO} == *"${REPO_PATH}"* ]]; then
			printf "    ${YELLOW}${REPO_PATH} Missing${NC}\n"
			# Prompt for action
			echo "Do you want to clone ${GIT_LINK}? (Y/y)"
			echo "or type (remove) to remove repo from dev list..."
			read REPLY
			if [[ "$REPLY" =~ ^[Yy]$ ]]; then
				mkdir -p ${ABS_REPO_PATH}
				git clone ${GIT_LINK} ${ABS_REPO_PATH} &&
					printf "${GREEN}${GIT_LINK} Cloned${NC}\n\n"

			elif [[ "$REPLY" =~ ^(Remove|remove|REMOVE) ]]; then
				sed -i "\|${line}|d" ${DEV_PUSH_LIST_PATH}
				printf "${RED}${REPO_PATH} Removed from dev list${NC}\n\n"
			fi
		else
			echo "${REPO_PATH}"
		fi
	done
	# Go back to initial directory
	cd ${CURRENT_DIR_SAVE}
}

clonealldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	while read line && [[ -n $line ]]; do
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		GIT_LINK="$(cut -d';' -f2 <<<"$line")"

		# Clone repo if repo dir exist
		if [[ ! -d ${ABS_REPO_PATH} ]]; then
			mkdir -p ${ABS_REPO_PATH}
			printf "${ABS_REPO_PATH} does not exist.\n"
			printf "${YELLOW}Cloning ${GIT_LINK}...${NC}\n"
			git clone ${GIT_LINK} ${ABS_REPO_PATH}
			# If Authentication failed, clone until successful or interrupted
			while [[ ${?} -eq 128 ]]; do
				git clone ${GIT_LINK} ${ABS_REPO_PATH}
			done
			# Remove directory if repo exists but not .git repo, then clone repo
		elif [[ ! -d "${ABS_REPO_PATH}/.git" ]]; then
			printf "${ABS_REPO_PATH}/.git does not exist.\n"
			printf "${RED}Removing ${ABS_REPO_PATH}...\n"
			rm -rf ${ABS_REPO_PATH} &&
				printf "${YELLOW}Cloning ${GIT_LINK}...${NC}\n" &&
				git clone ${GIT_LINK} ${ABS_REPO_PATH}

			# If Authentication failed, clone until successful or interrupted
			while [[ ${?} -eq 128 ]]; do
				printf "${YELLOW}Cloning ${GIT_LINK}...${NC}\n"
				git clone ${GIT_LINK} ${ABS_REPO_PATH}
			done
		fi
	done <${DEV_PULL_LIST_PATH}

	printf "${GREEN}Dev repo cloning complete!${NC}\n"
	cd ${CURRENT_DIR_SAVE}
}

removealldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	while read line && [[ -n $line ]]; do
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		GIT_LINK="$(cut -d';' -f2 <<<"$line")"

		# Remove directory if repo exists but not .git repo
		if [[ ! -d "${ABS_REPO_PATH}/.git" ]]; then
			printf "${RED}${ABS_REPO_PATH}/.git does not exist.\n"
			printf "\tSkipping ${ABS_REPO_PATH}...${NC}\n"
		elif [[ -d "${ABS_REPO_PATH}" ]]; then
			printf "${RED}Removing ${ABS_REPO_PATH}...${NC}\n"
			rm -rf ${ABS_REPO_PATH}
		fi
	done <${DEV_PULL_LIST_PATH}

	printf "${GREEN}Dev repo removal complete!${NC}\n"
	cd ${CURRENT_DIR_SAVE}
}

pushalldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f ${DEV_PUSH_LIST_PATH} ]]; then
		printf "${RED}${DEV_PUSH_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PUSH_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PUSH_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 1: Works well with `wait` command
	for line in $(cat ${DEV_PUSH_LIST_PATH}); do
		# continue of line is empty String
		[[ -z $line ]] && continue
		# Wait until another git commit finish processing if exist
		if [[ -n $(ps -fc | grep "git commit$" | head -n 1 | awk '{print $2}') ]]; then
			wait $(ps -fc | grep "git commit$" | head -n 1 | awk '{print $2}')
		fi
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		# Go to a Dev repo then push
		cd ${ABS_REPO_PATH}
		pushrepo
	done
	cd ${CURRENT_DIR_SAVE}
}

pullalldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 2: Ensures no leadiing line
	while read line && [[ -n $line ]]; do
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		# Go to a Dev repo then pull
		cd ${ABS_REPO_PATH}
		pullrepo
	done <${DEV_PULL_LIST_PATH}
	cd ${CURRENT_DIR_SAVE}
}

forcepullalldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 2: Ensures no leadiing line
	while read line && [[ -n $line ]]; do
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		# Go to a Dev repo then force pull
		cd ${ABS_REPO_PATH}
		forcepullrepo
	done <${DEV_PULL_LIST_PATH}
	cd ${CURRENT_DIR_SAVE}
}

statusdevpushrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f ${DEV_PUSH_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PUSH_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PUSH_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 2: Ensures no leadiing line
	while read line && [[ -n $line ]]; do
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<<"$line")"
		ABS_REPO_PATH=$(echo ${REPO_PATH} | sed -r "s,~,${HOME},")
		# Go to a Dev repo then git status
		cd ${ABS_REPO_PATH}
		git remote update
		checkremotechanges
	done <${DEV_PUSH_LIST_PATH}
	cd ${CURRENT_DIR_SAVE}
}

alias gpushdev=pushalldevrepo
alias gpulldev=pullalldevrepo
alias gfpulldev=forcepullalldevrepo
alias gstatusdev=statusdevpushrepo
alias grounddev=roundalldevrepo
alias gprintdevlists=printdevrepolists
alias gprintdev=printalldevrepo
alias gcheckdev=checkalldevrepos
alias gcreatedevlists=createalldevrepolists
alias gclonedev=clonealldevrepo
alias grmdev=removealldevrepo

# Resources: https://stackoverflow.com/a/3278427
# NOTE: Needs to run `git fetch` or `git remote update` first before running.
checkremotechanges() {
	CHANGES=$(git status --porcelain)
	UPSTREAM=${1:-'@{u}'}
	LOCAL=$(git rev-parse @)
	REMOTE=$(git rev-parse "$UPSTREAM")
	BASE=$(git merge-base @ "$UPSTREAM")

	if [[ $LOCAL = $REMOTE ]]; then # Check if no changes
		echo "$(pwd) Up-to-date"
	elif [[ $LOCAL = $BASE ]]; then # Check if needs to pull
		echo "$(pwd) Repo need to pull"
		# pullrepo
	elif [[ $REMOTE = $BASE ]]; then # Check if need to push
		echo "$(pwd) Repo need to push"
		# pushrepo
	else # Repo diverted. Need to merge
		printf "${RED} $(pwd) Repo diverged${NC}\n"
	fi

	if [[ -n ${CHANGES} ]]; then # Check for uncommited changes
		echo "$(pwd) Repo need to commit"
	fi
}

# TODO:
syncallrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	cd ~/Documents/wiki && checkremotechanges
	cd ~/Documents/wiki/wiki && checkremotechanges
	cd ~/.config/nvim && checkremotechanges
	cd ~/.tmuxinator && checkremotechanges
	dotupdate &&
		CHANGE_STATUS=$(checkremotechanges) && echo ${CHANGE_STATUS} &&
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
DEV="~/Documents/dev"
# Resources: https://forum.rclone.org/t/how-to-speed-up-google-drive-sync/8444/9
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
alias rccopy="rclone copy -vvP ${RCLONE_ARGS}"
alias rcsync="rclone sync -vvP ${RCLONE_ARGS}"
alias rcdevrmt="rclone sync ${DEV} GoogleDrive:Dev --backup-dir GoogleDrive:$(date '+%Y-%m-%d').Dev.bak -vvP ${RCLONE_ARGS}"
alias rcrmtdev="rclone sync GoogleDrive:Dev ${DEV} --backup-dir $(date '+%Y-%m-%d').Dev.bak -vvP ${RCLONE_ARGS}"

# Rsync
alias rsync="sudo rsync -ahHv --stats --no-inc-recursive --delete --delete-after"

# Syncthing
alias stg="open http://localhost:8384"
alias st="cd ~/Sync/"
alias stdev="cd ~/Sync/dev/"
alias stnote="cd ~/Sync/notes/"

MY_ENV_FILE='/etc/profile.d/jdk_environment.sh'

# Alternative dynamic JAVA_HOME
# https://stackoverflow.com/a/29622512/11850077

# Switch JDK version
setjavaopenjdkhome() {
	if [[ ! -e ${JDK_HOME} ]]; then
		echo "'${JDK_HOME}' does not exist"
		return 1
	fi

	# remove active java from $PATH - https://unix.stackexchange.com/a/108876
	export PATH=$(echo "$PATH" | sed -e "s,$JAVA_HOME/bin,,")

	if [[ "$(echo $JDK_HOME | grep "java-8")" ]]; then
		# For jdk 9
		sudo update-alternatives --set java "${JDK_HOME}/jre/bin/java"
	else
		# For jdk 11 and higher
		sudo update-alternatives --set java "${JDK_HOME}/bin/java"
	fi
	sudo update-alternatives --set javac "${JDK_HOME}/bin/javac"

	# Set JAVA_HOME AND JRE_HOME environment variables
	if [[ ! -e ${MY_ENV_FILE} ]]; then
		sudo touch ${MY_ENV_FILE}
	fi

	# Replace JAVA_HOME with $JDK_HOME path if exist, else append
	if grep -q 'JAVA_HOME=' ${MY_ENV_FILE}; then
		sudo sed -i "s,JAVA_HOME=.*,JAVA_HOME=${JDK_HOME}," ${MY_ENV_FILE}
	else
		echo "export JAVA_HOME=${JDK_HOME}" | sudo tee -a ${MY_ENV_FILE} >/dev/null
	fi

	# Add $JAVA_HOME/bin to $PATH
	if grep -q 'PATH=' ${MY_ENV_FILE}; then
		sudo sed -i "s,PATH=.*,PATH=\$PATH:\$JAVA_HOME/bin," ${MY_ENV_FILE}
	else
		echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a ${MY_ENV_FILE} >/dev/null
	fi

	source ${MY_ENV_FILE}
}

setjavaoraclejdkhome() {
	if [[ ! -e ${JDK_HOME} ]]; then
		echo "'${JDK_HOME}' does not exist"
		return 1
	fi

	# remove active java from $PATH - https://unix.stackexchange.com/a/108876
	export PATH=$(echo "$PATH" | sed -e "s,:$JAVA_HOME/bin,,")

	sudo update-alternatives --set java "${JDK_HOME}/bin/java"
	sudo update-alternatives --set javac "${JDK_HOME}/bin/javac"

	# Set JAVA_HOME AND JRE_HOME environment variables
	if [[ ! -e ${MY_ENV_FILE} ]]; then
		sudo touch ${MY_ENV_FILE}
	fi

	# Replace JAVA_HOME with $JDK_HOME path if exist, else append
	if grep -q 'JAVA_HOME=' ${MY_ENV_FILE}; then
		sudo sed -i "s,JAVA_HOME=.*,JAVA_HOME=${JDK_HOME}," ${MY_ENV_FILE}
	else
		echo "export JAVA_HOME=${JDK_HOME}" | sudo tee -a ${MY_ENV_FILE} >/dev/null
	fi

	# Add $JAVA_HOME/bin to $PATH
	if grep -q 'PATH=' ${MY_ENV_FILE}; then
		sudo sed -i "s,PATH=.*,PATH=\$PATH:\$JAVA_HOME/bin," ${MY_ENV_FILE}
	else
		echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a ${MY_ENV_FILE} >/dev/null
	fi

	source ${MY_ENV_FILE}
}

alias openjdk8="export JDK_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && setjavaopenjdkhome"
alias openjdk11="export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64 && setjavaopenjdkhome"
alias openjdk13="export JDK_HOME=/usr/lib/jvm/java-13-openjdk-amd64 && setjavaopenjdkhome"
alias oraclejdk8="export JDK_HOME=/usr/lib/jvm/jdk1.8.0_261 && setjavaoraclejdkhome"
alias oraclejdk11="export JDK_HOME=/usr/lib/jvm/jdk-11.0.8 && setjavaoraclejdkhome"
alias oraclejdk14="export JDK_HOME=/usr/lib/jvm/jdk-14.0.1 && setjavaoraclejdkhome"

# gtd shell script
alias on="gtd -lmspt"

# tmuxinator
alias mux="tmuxinator"

# Remove zone modifiers, attributes
alias rmzone='find . -name "*Zone.*" -type f && find . -name "*Zone.*" -type f -delete'
alias rmdattrs='find . -name "*dropbox.attrs" -type f && find . -name "*dropbox.attrs" -type f -delete'
alias rmwinjunk='find . \( -name "*Zone.*" -o -name "*dropbox.attrs" -o -name "desktop.ini" \) -type f && find . \( -name "*Zone.*" -o -name "*dropbox.attrs" -o -name "desktop.ini" \) -type f -delete'

# Neovide
alias nvide='neovide --multigrid --nofork --notabs --frame=none'

# WSL aliases
if [[ $(grep -i "Microsoft" /proc/version) ]]; then
	# Directory Aliases
	alias winhome="cd /c/Users/${WIN_USERNAME}"
	alias windocs="cd /c/Users/${WIN_USERNAME}/Documents"
	alias wintrade="cd /c/Users/${WIN_USERNAME}/OneDrive/Trading/Stocks"
	alias windown="cd /c/Users/${WIN_USERNAME}/Downloads"
	alias gdrv="cd /c/Users/${WIN_USERNAME}/Google Drive"
	alias odrv="cd /c/Users/${WIN_USERNAME}/OneDrive"
	alias drop="cd /c/Users/${WIN_USERNAME}/Dropbox"
	alias dropd="cd /c/Users/${WIN_USERNAME}/Dropbox/Dev"
	alias winproj="cd /c/Users/${WIN_USERNAME}/Projects/"
	alias winbin="cd /c/bin"

	# Secure files Aliases
	alias secenter="cd /c/Users/${WIN_USERNAME}/Documents; cmd.exe /C Secure.bat; cd ./Secure"
	alias seclock="cd /c/Users/${WIN_USERNAME}/Documents; cmd.exe /c Secure.bat"
	alias sec="cd /c/Users/${WIN_USERNAME}/Documents/Secure"
	alias secfiles="cd /c/Users/${WIN_USERNAME}/Documents/Secure"
	alias secdocs="cd /c/Users/${WIN_USERNAME}/Documents/Secure/EDocs"
	alias secpersonal="cd /c/Users/${WIN_USERNAME}/Documents/Secure/Personal"
	alias secbrowse="cd /c/Users/${WIN_USERNAME}/Documents/Secure; explorer.exe .; cd -"

	# Running Windows executable
	alias cmd='cmd.exe /C'
	alias pows='powershell.exe /C'
	alias exp='explorer.exe'

	if command -v wslview &>/dev/null; then
		alias open='wslview'
		alias wsl-open='wslview'
		alias start='wslview'
		alias wslstart='wslview'
		alias wstart='wslview'
	fi

	if command -v wsl-open &>/dev/null; then
		unalias wsl-open
		alias open='wsl-open'
		alias start='wsl-open'
		alias wslstart='wsl-open'
		alias wstart='wsl-open'
	fi

	if [[ -f '/c/wsl/bin/neovide.exe' ]]; then
		alias nvide='/c/wsl/bin/neovide.exe --multigrid --nofork --notabs --frame=none --wsl'
	else
		alias nvide='neovide --multigrid --nofork --notabs --frame=none --wsl'
	fi

	function mount_drive() {
		if [[ -z "${1+x}" ]]; then
			echo "error: missing drive letter"
			return 1
		fi

		# Check if only a letter
		if [ ${#1} -gt 1 ]; then
			echo "error: provide only a drive letter '${1}'"
			return 1
		fi

		# Check if is letter
		if [[ "${1}" =~ [^a-zA-Z] ]]; then
			echo "error: invalid drive letter '${1}'"
			return 1
		fi

		local drive_letter="$(echo "${1}" | awk '{print tolower($0)}')"

		if ! [[ -d "/mnt/${drive_letter}" ]]; then
			mkdir /mnt/"${drive_letter}"
		fi

		sudo mount -t drvfs "${drive_letter}:" "/mnt/${drive_letter}" && cd /mnt/"${drive_letter}"
	}

	function unmount_drive() {
		if [[ -z "${1+x}" ]]; then
			echo "error: missing drive letter"
			return 1
		fi

		# Check if only a letter
		if [ ${#1} -gt 1 ]; then
			echo "error: provide only a drive letter '${1}'"
			return 1
		fi

		# Check if is letter
		if [[ "${1}" =~ [^a-zA-Z] ]]; then
			echo "error: invalid drive letter '${1}'"
			return 1
		fi

		local drive_letter="$(echo "${1}" | awk '{print tolower($0)}')"

		sudo umount /mnt/"${drive_letter}"

		local res=${?}

		# 32 exit code no device mounted
		if [[ ${res} -eq 0 ]] || [[ ${res} -eq 32 ]]; then
			if [[ -d "/mnt/${drive_letter}" ]]; then
				sudo rmdir /mnt/"${drive_letter}"
			fi
		fi
	}

	alias mount='mount_drive'
	alias unmount='unmount_drive'

	# Yank currant path and convert to windows path
	function winpath() {
		printf "%s" "$(wslpath -w "$(pwd)")"
	}
	# Yank current path and convert to Windows path. Requires xclip
	alias wyp="winpath | xclip -selection clipboard && echo 'Current Windows path yanked to clipboard' || echo 'ERROR: Path not yanked!'"

	# DEPRECATED: For reference only
	# # cd to Windows path string literal
	# cdwinpath() {
	#   if [[ $# -eq 0 ]] ; then
	#     echo "Missing Windows path string arg"
	#     return
	#   fi
	#
	#   cd $(wslpath -ua "$*")
	# }
	# # Windows path only cd
	# alias wcd="cdwinpath"

	# Ref: https://gist.github.com/Gordin/67c9f5e995f4b625adf485eb791dea3e
	# Use builtin cd if possible, else treat as Windows path.
	function cd() {
		# Check if no arguments to make just typing cd<Enter> work
		# Also check if the first argument starts with a - and let cd handle it
		if [ $# -eq 0 ] || [[ $1 == -* ]]; then
			builtin cd $@
			return
		fi
		# If path exists, just cd into it
		# (also, using $* and not $@ makes it so you don't have to escape spaces any more)
		if [[ -d "$*" ]]; then
			builtin cd "$*"
			return
		else
			# Try converting from Windows to absolute Linux path and try again
			local wslpath="$(wslpath -ua "$@")"
			if [[ -d "$wslpath" ]]; then
				builtin cd "$wslpath"
				return
			fi
		fi
		# If both options don't work, just let the builtin cd handle it
		builtin cd "$*"
	}

	# Nameserver workaround for WSL2
	alias backupns='cat /etc/resolv.conf > /tmp/nameserver.bak'
	alias setns='echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf'
	alias restorens='cat /tmp/nameserver.bak | sudo tee /etc/resolv.conf'
	alias printns='cat /etc/resolv.conf'

	# gtd shell script for WSL
	alias on="gtd -pts"
fi

# Yank and pasting UNIX current working directory to system clipboard.
# Requires xclip.
alias yp='pwd | tr -d "\n" | cs clipboard && echo "Current UNIX path yanked to clipboard" || echo "ERROR: Path not yanked!"'
alias cdp='cd "`vs clipboard`" && clear'
