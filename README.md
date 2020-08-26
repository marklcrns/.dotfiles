# All my WSL and Linux dotfiles and configurations

Clone repo

```bash
git clone https://github.com/marklcrns/.dotfiles ~/.dotfiles
```

> **NOTE:** Could be anywhere other than `~/Projects` directory.

## Distribute Dotfiles

```bash
cd ~/Projects/.dotfile
./bin/tools/dotfiles/dotdist -VD -r .dotfilesrc . $HOME
```

## Packages Installation

```bash
cd ~/Projects/.dotfile
./scripts/install/install.sh
```

