#!/usr/bin/env bash

# =============================================================================
# Name: get-fil-extension.sh
# Type: Function
# Description: Get the provided file's extension (without the dot).
# =============================================================================

get_file_extension() {
  local file_name

  file_name="$(basename "$1")"
  echo "${file_name##*.}"
}
