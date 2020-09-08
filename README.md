# All my WSL and Linux Dotfiles and configurations

Clone repo

```bash
git clone https://github.com/marklcrns/.dotfiles ~/.dotfiles
```

## Packages Installation

```bash
cd ~/.dotfiles
./scripts/install/install.sh
```

## Auto Distribute Dotfiles

Distribute all dotfiles listed in `.dotfilesrc` (included in this repo) into
destination directory

Using my [dotfiles scripts](https://github.com/marklcrns/scripts/tree/master/tools/dotfiles)

```bash
# clone scripts
git clone https://github.com/marklcrns/scripts $HOME

cd ~/.dotfiles

# Distribute all dotfiles from `~/.dotfiles` into `$HOME` directory
$HOME/scripts/tools/dotfiles/dotdist -VD -r .dotfilesrc . $HOME
```

