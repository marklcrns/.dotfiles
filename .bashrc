# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Utility function to add a path into $PATH
# Ref: https://unix.stackexchange.com/q/334382
function add_to_path() {
  for path in ${2//:/ }; do
    if ! [[ "${!1}" =~ "${path%/}" ]]; then # ignore last /
      new_path="$path:${!1#:}"
      export "$1"="${new_path%:}" # remove trailing :
    fi
  done
}

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# Ref: https://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

alias sobash='source ~/.bashrc'
alias bashrc='nvim ~/.bashrc'

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Fuzzy file finder configurations
# Ref:
# https://github.com/junegunn/fzf/wiki/configuring-shell-key-bindings
# https://www.youtube.com/watch?v=qgg5jhi_els
# https://remysharp.com/2018/08/23/cli-improved
if [[ -f ~/.fzf.bash ]]; then
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
fi

[[ ! -f /usr/share/autojump/autojump.sh ]] || \
  . /usr/share/autojump/autojump.sh

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  nvim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
  }

# Taskwarrior add emojis
# Ref: http://jessachandler.com/2018/03/setup-task-and-time-warrior/
# https://twitter.com/pjf/status/852466839145795584
URGENT="2757"
DUETOMORROW="2690"
DUETODAY="2691"
OVERDUE="2639"
OK="2714"

# shows if any TaskWarrior tasks are in need of attention
function task_indicator {
  if [ `task +READY +OVERDUE count` -gt "0" ]  ; then
    printf "%b" "\u$OVERDUE"
  elif [ `task +READY +DUETODAY count` -gt "0" ]  ; then
    printf "%b" "\u$DUETODAY"
  elif [ `task +READY +DUETomorrow count` -gt "0" ]  ; then
    printf "%b" "\u$DUETOMORROW"
  elif [ `task +READY urgency \> 10 count` -gt "0" ]  ; then
    printf "%b" "\u$URGENT"
  else
    printf "%b" "\u$OK"
  fi
}
task="\$(task_indicator)"
addprompt=$task
PROMPT="$addprompt $PROMPT"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

if hash direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi
