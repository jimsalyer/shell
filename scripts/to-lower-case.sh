#!/usr/bin/env bash

# =============================================================================
# Name: to-lowercase.sh
# Type: Function
# Description: Convert the provided string to lowercase.
# =============================================================================

# shellcheck disable=SC2005

lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

lower_case() {
  echo "$(lower "$1")"
}

to_lower() {
  echo "$(lower "$1")"
}

to_lower_case() {
  echo "$(lower "$1")"
}
