#!/usr/bin/env bash

# =============================================================================
# Name: get-file-path.sh
# Type: Function
# Description: Get the provided file's path (without the file name). To include
#              a trailing slash, pass a second parameter.
# =============================================================================

# shellcheck disable=SC2005

get_file_path() {
  local file_path

  file_path="$(dirname "$1")"
  if [[ "$file_path" == . ]]; then
    echo ""
  elif [[ -n "$2" ]]; then
    echo "$file_path/"
  else
    echo "$file_path"
  fi
}
