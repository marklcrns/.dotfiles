# String ANSI colors
# Resources: https://stackoverflow.com/a/5947802/11850077
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Config files
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
alias aptupdate='sudo apt update && sudo apt upgrade -y'

# Directory Aliases
alias down='cd ~/Downloads'
alias docs='cd ~/Documents'
alias proj='cd ~/Projects'
alias dev='cd ~/Projects/Dev'
alias ref='cd ~/Projects/references'
alias drop='cd ~/Dropbox'
alias dropd='cd ~/Dropbox/Dev'

# tutorial https://www.youtube.com/watch?v=L9zfMeB2Zcc&app=desktop
alias bsync='browser-sync start --server --files "*"'
# Proxy configured to work with Django
# https://www.metaltoad.com/blog/instant-reload-django-npm-and-browsersync
alias bsync-proxy='browser-sync start --proxy 127.0.0.1:8000 --files "*"'

# Flask
alias flask='FLASK_APP=application.py FLASK_ENV=development FLASK_DEBUG=1 python -m flask run'

# Python
alias envactivate='source env/bin/activate'

# Make native commands verbose
alias mv='mv -v'
alias rm='rm -v'
alias cp='cp -v'
alias mkdir='mkdir -v'
alias rmdir='rmdir -v'
alias clear='clear -x' # keep buffer when clearing

# Resources: https://unix.stackexchange.com/a/125386
mkcd () {
	mkdir -pv -- "$1" && cd -P -- "$1"
}

touched() {
	touch -- "$1" && nvim -- "$1"
}

alias rm='trash-put -h; echo "\n\nUse \\\rm to use the built-in rm command"; false'

# Binaries
alias open='xdg-open'
alias ls='exa'
alias l='exa -l'
alias la='exa -la'
alias fd='fdfind'

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
alias wikidocs='cd ~/Documents/wiki'

# Remove debug.log files recursively (will also list all debug files before removal)
alias rmdebs='find . -name "debug.log" -type f; find . -name "debug.log" -type f -delete'
# Remove .log files recursively (will also list all .log files before removal)
alias rmlogs='find . -name "*.log" -type f; find . -name "*.log" -type f -delete'

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
alias gh='open https://github.com'
alias gist='open https://gist.github.com'
alias insigcommit='git add . && git commit -m "Insignificant commit" && git push'
alias commit='git commit'
alias commitall='git add . && git commit'

browsegithubrepo() {
	open `git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//'`| head -n 1 &
}
alias openrepo=browsegithubrepo

# Resources:
# Check repo existing files changes: https://stackoverflow.com/questions/5143795/how-can-i-check-in-a-bash-script-if-my-local-git-repository-has-changes
# Check repo for all repo changes: https://stackoverflow.com/a/24775215/11850077
# Check if in git repo: https://stackoverflow.com/questions/2180270/check-if-current-directory-is-a-git-repository
export CONF_REPO_LIST="\
	${DOTFILES}
	${HOME}/.cache/vim/session/
	${HOME}/.config/nvim/
	${HOME}/.lc/
	${HOME}/.timewarrior/
	${HOME}/.tmuxinator/
	${HOME}/Documents/wiki/
	${HOME}/scripts/
"

printallconfrepo() {
	echo ${CONF_REPO_LIST}
}

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

# NOTE: Aliases with '\n' must be string literal, while double quoting all
# in-line variable references  to read all string characters, otherwise will be
# truncated at the '\n'.
alias gprintconf='echo "${CONF_REPO_LIST}"'
alias gpullconf='gbulk -PV -l "${CONF_REPO_LIST}"'
alias gfpullconf='gbulk -fPV -l "${CONF_REPO_LIST}"'
alias gpushconf='gbulk -pV -l "${CONF_REPO_LIST}"'
alias gfpushconf='gbulk -fpV -l "${CONF_REPO_LIST}"'
alias gstatusconf='gbulk -sV -l "${CONF_REPO_LIST}"'

# Resources:
# Find: https://stackoverflow.com/a/15736463
# Loops: https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# Loop over lines in a variable: https://superuser.com/a/284226
# Wait: https://stackoverflow.com/questions/49823080/use-bash-wait-in-for-loop
# PID: https://www.cyberciti.biz/faq/linux-find-process-name/
DEV_REPO_DIR="${HOME}/Projects/Dev"
DEV_REPO_LIST_NAME="devrepolist.txt"
DEV_REPO_LIST_PATH=${DOTFILES}/${DEV_REPO_LIST_NAME}
DEV_PULL_LIST_FILE="devpulllist.txt"
DEV_PUSH_LIST_FILE="devpushlist.txt"
DEV_PULL_LIST_PATH=${DOTFILES}/${DEV_PULL_LIST_FILE}
DEV_PUSH_LIST_PATH=${DOTFILES}/${DEV_PUSH_LIST_FILE}

# # Convert dev repo list line to path absolute path
# convertdevlinetopath() {
#   local arg1=$1
#   # Replace ~ with absolute $HOME path
#   regex2="s,~(.*),${HOME}\1,"
#   # Get repo directory
#   retval=`echo $arg1 | sed -r "${regex1};${regex2}"`
# }

createalldevrepolists() {
	CURRENT_DIR_SAVE=$(pwd)
	# Get all dev repo and store in $DEV_REPO_LIST_PATH
	# Convert home path to ~ and truncate .git
	regex1="s,.*(/Projects/.*)/.git$,~\1,"

	# Create devpulllist.txt
	find ${DEV_REPO_DIR} -name ".git" | \
		sed -r "${regex1}" > ${DEV_PULL_LIST_PATH}

	# Create devpushlist.txt
	find ${DEV_REPO_DIR} -name ".git" -not -path "*/cloned-repos/*" | \
		sed -r "${regex1}" > ${DEV_PUSH_LIST_PATH}

	# Append repo links in pull list
	for line in $(cat ${DEV_PULL_LIST_PATH}); do
		GIT_REPO_PATH=$line
		# cd into repo
		ABS_PATH=`echo ${GIT_REPO_PATH} | sed -r "s,~,${HOME},"`
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
		ABS_PATH=`echo ${GIT_REPO_PATH} | sed -r "s,~,${HOME},"`
		cd ${ABS_PATH}
		# Get repo github link
		GIT_REPO_LINK="$(git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//')"
		# Append repo absolute path its github link in dev_repo_list.txt
		sed -i "s|^${GIT_REPO_PATH}$|${GIT_REPO_PATH};${GIT_REPO_LINK}|" ${DEV_PUSH_LIST_PATH}
	done

	[[ -f ${DEV_PULL_LIST_PATH} ]] && \
		echo "Created ${DEV_PULL_LIST_PATH}" && cat ${DEV_PULL_LIST_PATH}

	[[ -f ${DEV_PUSH_LIST_PATH} ]] && \
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
	regex1="s,.*(/Projects/.*)/.git$,~\1,"
	PULL_DEV_REPO="$(find ${DEV_REPO_DIR} -name ".git" | sed -r "${regex1}")"
	PUSH_DEV_REPO="$(find ${DEV_REPO_DIR} -name ".git" -not -path "*/cloned-repos/*" | sed -r "${regex1}")"

	echo "Checking untracked dev PULL repos..."
	for repo in $(echo ${PULL_DEV_REPO} | sed "s/\n/ /g")
	do
		ABS_REPO_PATH=`echo ${repo} | sed -r "s,~,${HOME},"`
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
				echo "${repo};${GIT_REPO_LINK}" >> ${DEV_PULL_LIST_PATH}
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
	for repo in $(echo ${PUSH_DEV_REPO} | sed "s/\n/ /g")
	do
		ABS_REPO_PATH=`echo ${repo} | sed -r "s,~,${HOME},"`
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
				echo "${repo};${GIT_REPO_LINK}" >> ${DEV_PUSH_LIST_PATH}
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
	for line in $(echo ${PULL_DEV_LIST} | sed "s/\n/ /g")
	do
		# Get repo path from line
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		GIT_LINK="$(cut -d';' -f2 <<< "$line" )"
		# Check if repo path in dev repos
		if [[ ! ${PULL_DEV_REPO} == *"${REPO_PATH}"* ]]; then
			printf "    ${YELLOW}${REPO_PATH} Missing${NC}\n"
			# Prompt for action
			echo "Do you want to clone ${GIT_LINK}? (Y/y)"
			echo "or type (remove) to remove repo from dev list..."
			read REPLY
			if [[ "$REPLY" =~ ^[Yy]$ ]]; then
				mkdir -p ${ABS_REPO_PATH}
				git clone ${GIT_LINK} ${ABS_REPO_PATH} && \
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
	for line in $(echo ${PUSH_DEV_LIST} | sed "s/\n/ /g")
	do
		# Get repo path from line
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		GIT_LINK="$(cut -d';' -f2 <<< "$line" )"
		# Check if repo path in dev repos
		if [[ ! ${PUSH_DEV_REPO} == *"${REPO_PATH}"* ]]; then
			printf "    ${YELLOW}${REPO_PATH} Missing${NC}\n"
			# Prompt for action
			echo "Do you want to clone ${GIT_LINK}? (Y/y)"
			echo "or type (remove) to remove repo from dev list..."
			read REPLY
			if [[ "$REPLY" =~ ^[Yy]$ ]]; then
				mkdir -p ${ABS_REPO_PATH}
				git clone ${GIT_LINK} ${ABS_REPO_PATH} && \
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
	if [[ ! -f  ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	while read line && [[ -n $line ]]; do
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		GIT_LINK="$(cut -d';' -f2 <<< "$line" )"

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
			rm -rf ${ABS_REPO_PATH} && \
				printf "${YELLOW}Cloning ${GIT_LINK}...${NC}\n" && \
				git clone ${GIT_LINK} ${ABS_REPO_PATH}

			# If Authentication failed, clone until successful or interrupted
			while [[ ${?} -eq 128 ]]; do
				printf "${YELLOW}Cloning ${GIT_LINK}...${NC}\n"
				git clone ${GIT_LINK} ${ABS_REPO_PATH}
			done
		fi
	done < ${DEV_PULL_LIST_PATH}

	printf "${GREEN}Dev repo cloning complete!${NC}\n"
	cd ${CURRENT_DIR_SAVE}
}

removealldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f  ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	while read line && [[ -n $line ]]; do
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		GIT_LINK="$(cut -d';' -f2 <<< "$line" )"

		# Remove directory if repo exists but not .git repo
		if [[ ! -d "${ABS_REPO_PATH}/.git" ]]; then
			printf "${RED}${ABS_REPO_PATH}/.git does not exist.\n"
			printf "\tSkipping ${ABS_REPO_PATH}...${NC}\n"
		elif [[ -d "${ABS_REPO_PATH}" ]]; then
			printf "${RED}Removing ${ABS_REPO_PATH}...${NC}\n"
			rm -rf ${ABS_REPO_PATH}
		fi
	done < ${DEV_PULL_LIST_PATH}

	printf "${GREEN}Dev repo removal complete!${NC}\n"
	cd ${CURRENT_DIR_SAVE}
}

pushalldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f  ${DEV_PUSH_LIST_PATH} ]]; then
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
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		# Go to a Dev repo then push
		cd ${ABS_REPO_PATH}
		pushrepo
	done
	cd ${CURRENT_DIR_SAVE}
}

pullalldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f  ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 2: Ensures no leadiing line
	while read line && [[ -n $line ]]; do
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		# Go to a Dev repo then pull
		cd ${ABS_REPO_PATH}
		pullrepo
	done < ${DEV_PULL_LIST_PATH}
	cd ${CURRENT_DIR_SAVE}
}

forcepullalldevrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f  ${DEV_PULL_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PULL_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PULL_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 2: Ensures no leadiing line
	while read line && [[ -n $line ]]; do
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		# Go to a Dev repo then force pull
		cd ${ABS_REPO_PATH}
		forcepullrepo
	done < ${DEV_PULL_LIST_PATH}
	cd ${CURRENT_DIR_SAVE}
}

statusdevpushrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	if [[ ! -f  ${DEV_PUSH_LIST_PATH} ]]; then
		printf "${RED}${DEV_PULL_LIST_FILE} in ${DOTFILES} does not exist${NC}\n"
		return 1
	elif [[ ! -s "${DEV_PUSH_LIST_PATH}" ]]; then
		printf "${YELLOW}${DEV_PUSH_LIST_FILE} in ${DOTFILES} is empty${NC}\n"
		return 1
	fi

	# Loop variation 2: Ensures no leadiing line
	while read line && [[ -n $line ]]; do
		# Convert line to abs PATH
		REPO_PATH="$(cut -d';' -f1 <<< "$line" )"
		ABS_REPO_PATH=`echo ${REPO_PATH} | sed -r "s,~,${HOME},"`
		# Go to a Dev repo then git status
		cd ${ABS_REPO_PATH}
		git remote update
		checkremotechanges
	done < ${DEV_PUSH_LIST_PATH}
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

	if [[ $LOCAL = $REMOTE ]]; then   # Check if no changes
		echo "$(pwd) Up-to-date"
	elif [[ $LOCAL = $BASE ]]; then   # Check if needs to pull
		echo "$(pwd) Repo need to pull"
		# pullrepo
	elif [[ $REMOTE = $BASE ]]; then  # Check if need to push
		echo "$(pwd) Repo need to push"
		# pushrepo
	else                              # Repo diverted. Need to merge
		printf "${RED} $(pwd) Repo diverged${NC}\n"
	fi

	if [[ -n ${CHANGES} ]]; then      # Check for uncommited changes
		echo "$(pwd) Repo need to commit"
	fi
}

# TODO:
syncallrepo() {
	CURRENT_DIR_SAVE=$(pwd)
	cd ~/Documents/wiki && checkremotechanges
	cd ~/Documents/wiki/wiki && checkremotechanges
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
alias rcopy="rclone copy -vvP ${RCLONE_ARGS}"
alias rsync="rclone sync -vvP ${RCLONE_ARGS}"
alias rcdevrmt="rclone sync ~/Projects/Dev GoogleDrive:Dev --backup-dir GoogleDrive:$(date '+%Y-%m-%d').Dev.bak -vvP ${RCLONE_ARGS}"
alias rcrmtdev="rclone sync GoogleDrive:Dev ~/Projects/Dev --backup-dir $(date '+%Y-%m-%d').Dev.bak -vvP ${RCLONE_ARGS}"


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
		# For jdk 8
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
		echo "export JAVA_HOME=${JDK_HOME}" | sudo tee -a ${MY_ENV_FILE} > /dev/null
	fi

	# Add $JAVA_HOME/bin to $PATH
	if grep -q 'PATH=' ${MY_ENV_FILE}; then
		sudo sed -i "s,PATH=.*,PATH=\$PATH:\$JAVA_HOME/bin," ${MY_ENV_FILE}
	else
		echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a ${MY_ENV_FILE} > /dev/null
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
		echo "export JAVA_HOME=${JDK_HOME}" | sudo tee -a ${MY_ENV_FILE} > /dev/null
	fi

	# Add $JAVA_HOME/bin to $PATH
	if grep -q 'PATH=' ${MY_ENV_FILE}; then
		sudo sed -i "s,PATH=.*,PATH=\$PATH:\$JAVA_HOME/bin," ${MY_ENV_FILE}
	else
		echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a ${MY_ENV_FILE} > /dev/null
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

# Remove zone modifiers, attributes and .~lock files
alias rmzone='find . -name "*Zone.*" && find . -name "*Zone.*" -delete'
alias rmdattrs='find . -name "*dropbox.attrs" && find . -name "*dropbox.attrs" -delete'
alias rmallmodattr="rmzone && rmdattr"
alias rmlock='find . -name ".~lock.*" && find . -name ".~lock.*" -delete'

# WSL aliases
if grep -i "microsoft" /proc/version &> /dev/null; then
	# Directory Aliases
	alias winhome="cd /mnt/c/Users/${WIN_USERNAME}"
	alias windocs="cd /mnt/c/Users/${WIN_USERNAME}/Documents"
	alias wintrade="cd /mnt/c/Users/${WIN_USERNAME}/OneDrive/Trading/Stocks"
	alias windown="cd /mnt/c/Users/${WIN_USERNAME}/Downloads"
	alias gdrv="cd /mnt/c/Users/${WIN_USERNAME}/Google Drive"
	alias odrv="cd /mnt/c/Users/${WIN_USERNAME}/OneDrive"
	alias drop="cd /mnt/c/Users/${WIN_USERNAME}/Dropbox"
	alias dropd="cd /mnt/c/Users/${WIN_USERNAME}/Dropbox/Dev"
	alias winproj="cd /mnt/c/Users/${WIN_USERNAME}/Projects/"
	alias winbin="cd /mnt/c/bin"

	# Secure files Aliases
	alias secenter="cd /mnt/c/Users/${WIN_USERNAME}; cmd.exe /C Secure.bat; cd ./Secure"
	alias seclock="cd /mnt/c/Users/${WIN_USERNAME}; cmd.exe /c Secure.bat"
	alias sec="cd /mnt/c/Users/${WIN_USERNAME}/Secure"
	alias secfiles="cd /mnt/c/Users/${WIN_USERNAME}/Secure"
	alias secdocs="cd /mnt/c/Users/${WIN_USERNAME}/Secure/EDocs"
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

	# Yank and pasting Windows current working directory to system clipboard.
	# Requires xclip.
	alias wyp="winpath | xclip -selection clipboard && echo 'Current Windows path yanked to clipboard' || echo 'ERROR: Path not yanked!'"
	alias wcdp="cdwinpath"

	# Nameserver workaround for WSL2
	alias backupns='cat /etc/resolv.conf > ~/nameserver.txt'
	alias setns='echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf'
	alias restorens='cat ~/nameserver.txt | sudo tee /etc/resolv.conf'
	alias printns='cat /etc/resolv.conf'

	# gtd shell script for WSL
	alias on="gtd -pts"
fi

# Yank and pasting UNIX current working directory to system clipboard.
# Requires xclip.
alias yp='pwd | tr -d "\n" | cs clipboard && echo "Current UNIX path yanked to clipboard" || echo "ERROR: Path not yanked!"'
alias cdp='cd "`vs clipboard`" && clear'
