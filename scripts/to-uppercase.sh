#!/usr/bin/env bash

# =============================================================================
# Name: to-uppercase.sh
# Type: Function
# Description: Convert the provided string to uppercase.
# =============================================================================

# shellcheck disable=SC2005

to_uppercase() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

to_upper() {
  echo "$(to_uppercase "$1")"
}
