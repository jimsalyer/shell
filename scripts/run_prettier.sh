#!/usr/bin/env bash

# Run Prettier on the file provided.
run_prettier() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local curr_dir
    local prettier

    curr_dir="$(dirname "$(realpath "$file")")"
    while [[ -d "$curr_dir" && -z "$prettier" ]]; do
      [[ -f "$curr_dir/node_modules/.bin/prettier" ]] && prettier="$curr_dir/node_modules/.bin/prettier"
      curr_dir="${curr_dir%/*}"
    done

    if [[ -f "$prettier" ]]; then
      echo "Running local version of Prettier"
      "$prettier" -w "$file"
    elif [[ "$(command -v prettier)" ]]; then
      echo "Running global version of Prettier"
      prettier -w "$file"
    else
      echo "Running remote version of Prettier"
      npx prettier -w "$file"
    fi
  else
    echo "The file \"$file\" does not exist."
  fi
}

run_prettier "$@"
unset -f run_prettier
