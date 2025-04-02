#!/usr/bin/env bash

# =============================================================================
# Name: reload.sh
# Type: Function
# Description: Cross platform way to reload the current shell environment
# =============================================================================

reload() {
  local shell
  shell="$(basename "$SHELL")"
  exec "$shell"
}

rl() {
  reload
}
