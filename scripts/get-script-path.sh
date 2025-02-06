#!/usr/bin/env bash

# =============================================================================
# Name: get-script-path.sh
# Type: Function
# Description: Get the current script's path.
# =============================================================================

# shellcheck disable=SC2005

get_script_path() {
  script_path="${0:a:h}"
  if [[ -z "$script_path" ]]; then
    script_path="$(realpath "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")"
    script_path="$(dirname "$script_path")"
  fi
  echo "$script_path"
}
