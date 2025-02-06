#!/usr/bin/env bash

# =============================================================================
# Name: list-paths.sh
# Type: Function
# Description: List all the entries in PATH.
# =============================================================================

list_paths() {
  echo "$PATH" | tr ':' '\n'
}
