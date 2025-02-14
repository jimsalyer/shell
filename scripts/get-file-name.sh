#!/usr/bin/env bash

# =============================================================================
# Name: get-file-name.sh
# Type: Function
# Description: Get the provided file's name (without the path and extension).
#              To include the extension, pass a second parameter.
# =============================================================================

# shellcheck disable=SC2005

get_file_name() {
  local file_name

  file_name="$(basename "$1")"
  if [[ -n "$2" ]]; then
    echo "$file_name"
  else
    echo "${file_name%.*}"
  fi
}
