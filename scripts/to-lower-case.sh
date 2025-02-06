#!/usr/bin/env bash

# =============================================================================
# Name: to-lower-case.sh
# Type: Function
# Description: Convert the provided string to lower case.
# =============================================================================

# shellcheck disable=SC2005

to_lower_case() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}
