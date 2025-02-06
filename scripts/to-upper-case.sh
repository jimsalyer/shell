#!/usr/bin/env bash

# =============================================================================
# Name: to-upper-case.sh
# Type: Function
# Description: Convert the provided string to upper case.
# =============================================================================

# shellcheck disable=SC2005

to_upper_case() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}
