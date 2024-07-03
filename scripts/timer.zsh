start_timer() {
  timer=$(($(gdate +%s%0N) / 1000000))
  echo 'Timer started'
}

stop_timer() {
  if [ $timer ]; then
    now=$(($(gdate +%s%0N) / 1000000))
    elapsed=$(($now - $timer))

    echo "Timer ran for ${elapsed}ms"
    unset timer
  fi
}
