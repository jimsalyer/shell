#!/usr/bin/env bash

# =============================================================================
# Name: list-sam-versions.sh
# Type: Function
# Description: List installed SAM CLI versions.
# Dependencies: sam
# =============================================================================

list_sam_versions() {
  for path in /usr/local/aws-sam-cli/*/; do
    dir="$(basename "$path")"
    if [[ "$dir" != current ]]; then
      echo "$dir"
    fi
  done
}
