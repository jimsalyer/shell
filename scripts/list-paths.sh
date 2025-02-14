#!/usr/bin/env bash

# =============================================================================
# Name: list-paths.sh
# Type: Function
# Description: List all the entries in PATH.
# =============================================================================

# shellcheck disable=SC2005

list_paths() {
  echo "$PATH" | tr ':' '\n'
}

paths() {
  echo "$(list_paths)"
}
