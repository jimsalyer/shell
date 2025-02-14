#!/usr/bin/env bash

# =============================================================================
# Name: to-lowercase.sh
# Type: Function
# Description: Convert the provided string to lowercase.
# =============================================================================

# shellcheck disable=SC2005

to_lowercase() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

to_lower() {
  echo "$(to_lowercase "$1")"
}
