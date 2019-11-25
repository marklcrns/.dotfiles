# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Solution for the npm issue. Also includes VS Code Path
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Windows System32 Path (for cmd.exe, powershell.exe, notepad.exe, etc)
export PATH=$PATH:/mnt/c/Windows/System32:/mnt/c/Windows:/mnt/c/Windows/System32/wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0

# VS Code and VS Code Insiders Path
export PATH=$PATH:/mnt/c/Users/Mark/AppData/Local/Programs/Microsoft\ VS\ Code/bin
export PATH=$PATH:/mnt/c/Users/Mark/AppData/Local/Programs/Microsoft\ VS\ Code\ Insiders/bin

# Java Home/JDK Path
export JAVA_HOME=~/jdk-13.0.1
export PATH=$JAVA_HOME/bin:$PATH

# Path to alternate neovim from squashfs-root
export PATH=~/squashfs-root/usr/bin:$PATH

# Path to browsers
export PATH=$PATH:/mnt/c/Program\ Files/Mozilla\ Firefox/
export PATH=$PATH:/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/

# tldr Config
# Repo: https://github.com/raylee/tldr
export PATH=$PATH:~/bin
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'

# truncate command line prompt user
DEFAULT_USER=`whoami`

# Activate dir_colors 256dark theme
if [ -f ~/.dircolors ]; then
  eval `dircolors ~/.dircolors`
fi

# Sends to home directory on zsh startup
# if [ -t 1 ]; then
#  cd ~
# fi

# Path to your oh-my-zsh installation.
export ZSH="/home/marklcrns/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "bira" "myCobalt2" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export VISUAL="nvim"
export EDITOR=$VISUAL

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias sozsh='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'

# Aliases moved to ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Fuzzy file finder configurations
# resources:
# https://github.com/junegunn/fzf/wiki/configuring-shell-key-bindings
# https://www.youtube.com/watch?v=qgg5jhi_els
# https://remysharp.com/2018/08/23/cli-improved

# use ~~ as the trigger sequence instead of the default **
#export FZF_COMPLETION_TRIGGER='~~'

# environment vaiable for exluding .git and node_modules directory
fd_options="--follow --exclude .git --exclude node_modules --exclude env --color=always"

# for faster traversal with git ls-tree
#export FZF_DEFAULT_COMMAND='
  #(git ls-tree -r --name-only head ||
   #find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      ##sed s/^..//) 2> /dev/null'

# default search filter command
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type $fd_options"

# apply fd_options variable to ctrl-t and alt-c
export FZF_CTRL_T_COMMAND="fd $fd_options"
export FZF_ALT_C_COMMAND="fd --type d $fd_options"

# alternative default options
#export FZF_DEFAULT_OPTS="--bind='ctrl-e:execute(code {})+abort' --ansi --height 70% --layout=reverse --inline-info --preview-window 'bottom:70%:hidden' --bind='ctrl-o:toggle-preview' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

# default options with preview with bat > highlight > cat > tree
# also with key bindings:
# f2: toggle-preview
# ctrl-d: half-page-down
# ctrl-u: half-page-update
# ctrl-a: select-all+accept
# ctrl-y: yank current selection to clipboard using xclip
export FZF_DEFAULT_OPTS="--ansi --height 70% -1 --reverse --multi --inline-info
                 --preview '[[ \$(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (bat --style=header --color=always {} ||
                 highlight -O ansi -l {} 2> /dev/null ||
                 cat {} ||
                 tree -c {}) 2> /dev/null | head -200'
                 --preview-window='bottom:70%:wrap:hidden'
                 --bind='f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute(echo {} | xclip -selection clipboard || echo {} | xclip),ctrl-e:execute(wsl-open {})'"

# ctrl-t options
export FZF_CTRL_T_OPTS="--ansi --preview '(bat --color=always --decorations=always --style=header,grid --line-range :300 {} 2> /dev/null || cat {} || tree -c {}) 2> /dev/null | head -200'"

# ctrl-r options
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"

# alternative alt-c search filter command
#export fzf_alt_c_command="rg --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"

# alt-c options will open preview window for tree
export FZF_ALT_C_OPTS="--preview 'tree -c {} | head -200'"

# alias for opening nvim on fzf selection
alias nvimfzf='nvim "$(fzf)"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


## pyenv PATH
## Repo: https://github.com/pyenv/pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
##eval "$(pyenv virtualenv-init -)"

# lets vim/nvim to use $VIRTUAL_ENV interpreter when activated
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

