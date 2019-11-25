# Addition aliases for .basrc and .zshrc

# Directories Aliases
alias home='cd /mnt/c/Users/Mark; clear'
alias docs='cd /mnt/c/Users/Mark/Documents; clear'
alias trade='cd /mnt/c/Users/Mark/OneDrive/Trading/Stocks; clear'
alias down='cd /mnt/c/Users/Mark/Downloads; clear'

alias work='cd /mnt/c/Users/Mark/Programming; clear'
alias workgit='cd /mnt/c/Users/Mark/Programming/GitHub\ Repositories; clear'

alias res='cd /mnt/c/Users/Mark/Programming/Resources; clear'
alias reslinux='cd /mnt/c/Users/Mark/Programming/Resources/Windows\ System/Linux/WSL; clear'

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
alias open='wsl-open'
alias explore='explorer.exe'
alias firefox='firefox.exe'
alias chrome='chrome.exe'

# Websites
alias gh='open https://github.com; clear'
alias repo='open `git remote -v | grep fetch | awk "{print $2}" | sed 's/git@/http:\/\//' | sed "s/com:/com\//"`| head -n1'
alias gist='open https://gist.github.com; clear'

# live browser server
alias live='http-server'

# Flask
alias flask='FLASK_APP=app.py FLASK_DEBUG=1 python -m flask run --port 8080'

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

# Copy and pasting current working directory from and to clipboard
alias pwdc='pwd | cs clipboard; clear'
alias pwdp='cd "`vs clipboard`"; clear'

# Remapping native commands with newer programs
alias ls='exa'

