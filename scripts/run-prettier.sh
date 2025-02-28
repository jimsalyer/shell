#!/usr/bin/env bash

# =============================================================================
# Name: run-prettier.sh
# Type: Function
# Description: Run Prettier on the file provided.
# Dependencies: node
# =============================================================================

run_prettier() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local curr_dir
    local package_dir

    curr_dir="$(dirname "$(realpath "$file")")"
    while [[ -d "$curr_dir" && -z "$package_dir" ]]; do
      [[ -f "$curr_dir/package.json" ]] && package_dir="$curr_dir"
      curr_dir="${curr_dir%/*}"
    done

    if [[ -d "$package_dir" ]]; then
      local prettier_dir
      prettier_dir="$package_dir/node_modules/prettier"

      if [[ -d "$prettier_dir" ]]; then
        echo "Running local version of Prettier"
        node "$prettier_dir/bin-prettier.js" -w "$file"
      elif [[ "$(command -v prettier)" ]]; then
        echo "Running global version of Prettier"
        prettier -w "$file"
      else
        echo "Running remote version of Prettier"
        npx prettier -w "$file"
      fi
    else
      echo "Could not find any package.json files at or above \"$file\"."
    fi
  else
    echo "The file \"$file\" does not exist."
  fi
}
