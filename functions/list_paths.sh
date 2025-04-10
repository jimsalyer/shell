#!/usr/bin/env bash
# shellcheck disable=SC2005

# Lists all directories in the PATH variable, one per line
list_paths() {
  echo "$PATH" | tr ':' '\n'
}
