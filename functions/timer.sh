#!/usr/bin/env bash
# shellcheck disable=SC2005

# Timer functions to get elapsed time on a given piece of logic

_date() {
  if [[ "$OSTYPE" == darwin* ]]; then
    echo "$(gdate "$1")"
  else
    echo "$(date "$1")"
  fi
}

start_timer() {
  timer_name="'$1' timer"
  timer_name="${timer_name/\'\' t/T}"
  timer="$(($(_date +%s%0N) / 1000000))"
  echo "$timer_name started"
}

stop_timer() {
  if [[ "$timer" ]]; then
    now="$(($(_date +%s%0N) / 1000000))"
    elapsed="$((now - timer))"

    echo "$timer_name ran for ${elapsed}ms"
    unset timer
    unset timer_name
  fi
}
