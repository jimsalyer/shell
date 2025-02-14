#!/usr/bin/env bash

# =============================================================================
# Name: run-prettier.sh
# Type: Function
# Description: Run Prettier on the file provided.
# Dependencies: node
# =============================================================================

run_prettier() {
  local file="$1"
  if [[ -d "$(dirname "$file")/node_modules/prettier" ]]; then
    echo "Running local version of Prettier"
    node "$(dirname "$file")/node_modules/prettier/bin-prettier.js" -w "$file"
  elif [[ "$(command -v prettier)" ]]; then
    echo "Running global version of Prettier"
    prettier -w "$file"
  else
    echo "Running remote version of Prettier (npx)"
    npx prettier -w "$file"
  fi
}
