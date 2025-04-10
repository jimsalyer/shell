#!/usr/bin/env bash

# Get the absolute path of the script
get_script_path() {
  pushd . > '/dev/null'
  local script_path="${BASH_SOURCE[0]:-$0}"

  while [[ -L "$script_path" ]]; do
    cd "$(dirname -- "$script_path")" || exit
    script_path="$(readlink -f -- "$script_path")"
  done

  cd "$(dirname -- "$script_path")" > /dev/null || exit
  script_path="$(pwd)"
  popd > /dev/null || exit
  echo "$script_path"
}
