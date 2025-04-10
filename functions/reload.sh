#!/usr/bin/env bash

# Cross platform way to reload the current shell environment
reload() {
  [[ -z "$SHELL" ]] && SHELL="$(ps -p $$ -o comm=)"
  TERM="${TERM:-xterm-256color}"
  env -i HOME="$HOME" SHELL="$SHELL" TERM="$TERM" "$SHELL" -l
}
