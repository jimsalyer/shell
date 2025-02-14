#!/usr/bin/env bash

# =============================================================================
# Name: run-prettier.sh
# Type: Function
# Description: Run Prettier on the files/folders provided.
# Dependencies: node
# =============================================================================

run_prettier() {
  if [[ -d "./node_modules/prettier" ]]; then
    echo "Running local version of Prettier"
    node "./node_modules/prettier/bin-prettier.js" -w "$1"
  elif [[ "$(command -v prettier)" ]]; then
    echo "Running global version of Prettier"
    prettier -w "$1"
  else
    echo "Running remote version of Prettier (npx)"
    npx prettier -w "$1"
  fi
}
