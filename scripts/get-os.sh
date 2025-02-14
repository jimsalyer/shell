#!/usr/bin/env bash

# =============================================================================
# Name: get-os.sh
# Type: Function
# Description: Get operating system name.
# =============================================================================

# shellcheck disable=SC2005

get_os() {
  if [[ "$OSTYPE" == cygwin || "$OSTYPE" == msys || "$OSTYPE" == win32 ]]; then
    echo win
  elif [[ "$OSTYPE" == darwin* ]]; then
    echo macos
  elif [[ "$OSTYPE" == freebsd* ]]; then
    echo freebsd
  elif [[ "$OSTYPE" == linux-gnu* ]]; then
    echo linux
  fi
}

os() {
  echo "$(get_os)"
}
