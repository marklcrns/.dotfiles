#!/bin/bash

# Ref: https://stackoverflow.com/a/19733629/11850077

TASK_DIR="$HOME/Docs/wiki/wiki/md/diary"

printf "Now watching $TASK_DIR\nfor file changes..."

while true; do
  inotifywait -qe modify,create,delete -r $TASK_DIR && \
    task sync
  done
