#!/usr/bin/env bash
# shellcheck disable=SC2005

# Get operating system name
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
