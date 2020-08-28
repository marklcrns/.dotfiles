# Dotfiles Manager Scripts

Dotfiles manager to automate dotfiles syncing and backing up.

## Scripts

- `dotdist` -- Distribute all repository dotfiles into local or specified
  destination directory.
- `dotupdate` -- Update dotfiles repository of all local or specified dotfiles
  directory.
- `dotbackup` -- Backup all local dotfiles into `~/.dotfiles.bak`.
- `dotclearbak` -- Clean and limit dotfiles backup directory of specified
  amount (deletes oldest backup when above limit).

## TODO

- Remove empty directories when detecting changes and after deletion
