#!/usr/bin/env bash

# =============================================================================
# Name: get-file-path.sh
# Type: Function
# Description: Get the provided file's path (without the file name). To include
#              a trailing slash, pass a second parameter.
# =============================================================================

# shellcheck disable=SC2005

get_file_path() {
  local include_trailing_slash=false
  local path

  if [[ -n "$2" ]]; then
    include_trailing_slash=true
  fi

  path="$(dirname "$1")"
  if [[ "$path" == . ]]; then
    echo ""
  elif [[ "$include_trailing_slash" ]]; then
    echo "$path/"
  else
    echo "$path"
  fi
}
