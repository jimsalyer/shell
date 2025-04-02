#!/usr/bin/env bash

# =============================================================================
# Name: to-uppercase.sh
# Type: Function
# Description: Convert the provided string to uppercase.
# =============================================================================

# shellcheck disable=SC2005

upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

upper_case() {
  echo "$(upper "$1")"
}

to_upper() {
  echo "$(upper "$1")"
}

to_upper_case() {
  echo "$(upper "$1")"
}
