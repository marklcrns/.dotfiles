#!/bin/bash

# Ref: https://superuser.com/a/181543

TASK_DIR="$HOME/Docs/wiki/wiki/md/diary"
TODAY=`date +"%Y-%m-%d"`

inotifywait -e close_write,moved_to,create -m $TASK_DIR |
  while read -r directory events filename; do
    if [ "$filename" = "$TODAY.md" ]; then
      task sync
    fi
  done
