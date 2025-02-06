#!/usr/bin/env bash

# =============================================================================
# Name: refresh-env.sh
# Type: Function
# Description: Run a batch script to refresh the environment variables. This
#              function is meant for a Windows system running Git Bash.
# =============================================================================

refresh_env() {
  "$(dirname "${BASH_SOURCE[0]}")"/refresh-env.cmd
}
