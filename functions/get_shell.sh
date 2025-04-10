#!/usr/bin/env bash
# shellcheck disable=SC2005

# Get the current process shell
get_shell() {
  echo "$(ps -p $$ -o comm=)"
}
