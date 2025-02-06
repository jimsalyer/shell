#!/usr/bin/env bash

# =============================================================================
# Name: timer.sh
# Type: Function (2)
# Description: Timer functions to get elapsed time on a given piece of logic
# =============================================================================

start_timer() {
  timer="$(($(date +%s%0N) / 1000000))"
  echo "Timer started"
}

stop_timer() {
  if [[ "$timer" ]]; then
    now="$(($(date +%s%0N) / 1000000))"
    elapsed="$((now - timer))"

    echo "Timer ran for ${elapsed}ms"
    unset timer
  fi
}
