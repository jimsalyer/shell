#!/usr/bin/env bash

# =============================================================================
# Name: get-shell.sh
# Type: Function
# Description: Get the current process' shell.
# =============================================================================

# shellcheck disable=SC2005

get_shell() {
  local process_name
  process_name="$(echo "$(ps -o command -p $$)")"
  process_name="${process_name//[$'\n']}"
  echo "${process_name#COMMAND}"
}

shell() {
  echo "$(get_shell)"
}
