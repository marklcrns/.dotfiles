# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Utility function to add path into $PATH
# Ref: https://unix.stackexchange.com/q/334382
function add_to_path() {
  for p in ${(s.:.)2}; do
    if [[ ! "${(P)1}" =~ "${p%/}" ]]; then
      new_path="$p:${(P)1#:}"
      export "$1"="${new_path%:}"
    fi
  done
}

# truncate command line prompt user
DEFAULT_USER=`whoami`

# Sends to home directory on zsh startup
# if [ -t 1 ]; then
#  cd ~
# fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncommnt the following line if you want to disable marking untracked files
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

# Keep commandl line history in .zsh_history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh

# Accepts auto-suggestion with ctrl-x in vi mode
#ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(down-history)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
bindkey '^x' autosuggest-accept
bindkey '^z' autosuggest-toggle

# Vi mode
# Resources:
# https://dougblack.io/words/zsh-vi-mode.html
# https://www.youtube.com/watch?v=eLEo4OQ-cuQ&t=37s

# # # Change cursor shape for different vi modes.
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] ||
#      [[ $1 = 'block' ]]; then
#     echo -ne '\e[1 q'
#   elif [[ ${KEYMAP} == main ]] ||
#        [[ ${KEYMAP} == viins ]] ||
#        [[ ${KEYMAP} = '' ]] ||
#        [[ $1 = 'beam' ]]; then
#     echo -ne '\e[5 q'
#   fi
# }
# zle -N zle-keymap-select
# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
MODE_INDICATOR="%F{yellow}+%f"

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Edit line in vim with ctrl-o:
autoload edit-command-line; zle -N edit-command-line
bindkey '^o' edit-command-line

export KEYTIMEOUT=1


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
# Ref:
# https://github.com/junegunn/fzf/wiki/configuring-shell-key-bindings
# https://www.youtube.com/watch?v=qgg5jhi_els
# https://remysharp.com/2018/08/23/cli-improved
if [[ -f ~/.fzf.zsh ]]; then
  . ~/.fzf.zsh

  # use ~~ as the trigger sequence instead of the default **
  #export FZF_COMPLETION_TRIGGER='~~'

  # environment vaiable for exluding directories
  fd_options="--follow --hidden --exclude .git --exclude node_modules --exclude env --exclude __pycache__ --color=always"

  # for faster traversal with git ls-tree
  #export FZF_DEFAULT_COMMAND='
  #(git ls-tree -r --name-only head ||
  #find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
  ##sed s/^..//) 2> /dev/null'

  # default search filter command
  export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fdfind --type f $fd_options"

  # apply fd_options variable to ctrl-t and alt-c
  export FZF_CTRL_T_COMMAND="fdfind --type f $fd_options"
  export FZF_ALT_C_COMMAND="fdfind --type d $fd_options"

  # alternative default options
  #export FZF_DEFAULT_OPTS="--bind='ctrl-e:execute(code {})+abort' --ansi --height 70% --layout=reverse --inline-info --preview-window 'bottom:70%:hidden' --bind='ctrl-o:toggle-preview' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

  # default options with preview with bat > highlight > cat > tree
  # also with key bindings:
  # ?: toggle-preview
  # ctrl-e: xdg-open
  # ctrl-d: half-page-down
  # ctrl-u: half-page-update
  # ctrl-a: select-all+accept
  # ctrl-y: yank current selection to clipboard using xclip
  # ctrl-z: toggle-preview-wrap
  # up arrow: preview scroll up
  # down arrow: preview scroll down
  export FZF_DEFAULT_OPTS="--ansi --height 90% -1 --reverse --multi --inline-info
    --preview '[[ \$(file --mime {}) =~ binary ]] &&
    echo {} is a binary file ||
    (bat --style=numbers --color=always {} ||
    highlight -O ansi -l {} 2> /dev/null ||
    cat {} ||
    tree -c {}) 2> /dev/null | head -200'
      --preview-window='bottom:55%:wrap:hidden'
      --bind='ctrl-z:toggle-preview-wrap,?:toggle-preview,ctrl-l:cancel,ctrl-d:preview-page-down,ctrl-u:preview-page-up,ctrl-a:select-all,ctrl-y:execute(echo {} | xclip -selection clipboard || echo {} | xclip),ctrl-e:execute(wsl-open {})'"

  # ctrl-t options
  export FZF_CTRL_T_OPTS="--ansi --preview '(bat --color=always --decorations=always --style=numbers,grid --line-range :300 {} 2> /dev/null || cat {} || tree -c {}) 2> /dev/null | head -200'"

  # ctrl-r options
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"

  # alternative alt-c search filter command
  #export fzf_alt_c_command="rg --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"

  # alt-c options will open preview window for tree
  export FZF_ALT_C_OPTS="--preview 'tree -c {} | head -200'"

  # required for zsh fzf plugin
  export FZF_BASE="$HOME/.fzf"
fi

[[ ! -f /usr/share/autojump/autojump.zsh ]] || \
  . /usr/share/autojump/autojump.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

if hash direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
