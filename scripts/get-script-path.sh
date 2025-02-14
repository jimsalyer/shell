#!/usr/bin/env bash

# =============================================================================
# Name: get-script-path.sh
# Type: Function
# Description: Get the current script's path.
# =============================================================================

# shellcheck disable=SC2005

get_script_path() {
  echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
}

script_path() {
  echo "$(get_script_path)"
}
