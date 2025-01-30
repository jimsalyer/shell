#!/usr/bin/env bash

# shellcheck disable=SC2005
get_script_path() {
  echo "$(dirname "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")"
}
