#!/usr/bin/env bash

# =============================================================================
# Name: exit-script.sh
# Type: Function
# Description: Cross platform way to exit the current script
# =============================================================================

exit_script() {
  kill -SIGINT $$
}
