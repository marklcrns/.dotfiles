# Additional aliases for .basrc and .zshrc

# Directories Aliases
alias home='cd /mnt/c/Users/Mark; clear'
alias docs='cd /mnt/c/Users/Mark/Documents; clear'
alias trade='cd /mnt/c/Users/Mark/OneDrive/Trading/Stocks; clear'
alias down='cd /mnt/c/Users/Mark/Downloads; clear'

alias work='cd ~/Work; clear'
alias workgit='cd ~/Work/GitHub\ Repositories; clear'

alias res='cd ~/Work/Resources; clear'
alias reslinux='cd ~/Work/Resources/WSL; clear'

# Secure files Aliases
alias seclock='cd /mnt/c/Users/Mark/Documents; cmd.exe /c ./Folder\ Lock.bat; clear'
alias sec='cd /mnt/c/Users/Mark/Documents/Secure/; clear'
alias secfiles='cd /mnt/c/Users/Mark/Documents/Secure; clear'
alias secdocs='cd /mnt/c/Users/Mark/Documents/Secure/e-Files; clear'
alias secpersonal='cd /mnt/c/Users/Mark/Documents/Secure/Personal; clear'
alias secenter='cd /mnt/c/Users/Mark/Documents; cmd.exe /C ./Folder\ Lock.bat; cd ./Secure; clear'
alias secbrowse='cd /mnt/c/Users/Mark/Documents/Secure; explorer.exe .; cd -; clear'

# Editors Aliases
alias subl='/mnt/c/Program\ Files/Sublime\ Text\ 3/subl.exe'
alias charm='/mnt/c/Users/Mark/AppData/Local/JetBrains/Toolbox/apps/PyCharm-C/ch-0/192.6817.19/bin/pycharm64.exe'

# Running Windows executable
alias cmd='cmd.exe /C'
alias ps='powershell.exe /C'
alias open='xdg-open'
alias explore='explorer.exe'
alias firefox='firefox.exe'
alias chrome='chrome.exe'

# Websites
alias gh='open https://github.com; clear'
alias repo='open `git remote -v | grep fetch | awk "{print $2}" | sed 's/git@/http:\/\//' | sed "s/com:/com\//"`| head -n1'
alias gist='open https://gist.github.com; clear'

# live browser server
alias live='http-server'
alias browsync='browser-sync start --server --files "*/**"'

# Flask
alias flask='FLASK_APP=app.py FLASK_DEBUG=1 python -m flask run --port 8080'

# Python env
alias env-activate='source env/bin/activate'

# Shortcut Commands

## xclip shortcuts
### use pipe before the alias command to work with xclip
### https://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard#answer-5130969
alias c='xclip'
alias v='xclip -o'
alias cs='xclip -selection'
alias vs='xclip -o -selection'

# Remove debug.log files recursively (will also list all debug files before removal)
alias rmdebs='find . -name "debug.log" -type f; find . -name "debug.log" -type f -delete'
# Remove .log files recursively (will also list all .log files before removal)
alias rmlogs='find . -name "*.log" -type f; find . -name "*.log" -type f -delete'
# Remove .root files recuresively (will also list all debug files before removal)
alias rmroot='find . -name "*.root" -type f; find . -name "*.root" -type f -delete'

# Copy and pasting current working directory from and to clipboard
alias pwdc='pwd | cs clipboard; clear'
alias pwdp='cd "`vs clipboard`"; clear'

# Remapping native commands with newer programs
alias ls='exa'

# Updating dotfiles Repo
alias dotupdate='cd ~/Work/GitHub\ Repositories/dotfiles;yes | cp -ivr ~/.bashrc ~/.bash_aliases ~/.tmux.conf ~/.vimrc ~/.zshrc ~/.config/nvim/init.vim ~/.config/nvim/coc-settings.json ~/.profile ~/.ctags.d/ ~/.muttrc .;git add .;clear; git status'

alias linuxgui='startxfce4'
