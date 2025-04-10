#!/usr/bin/env bash

# Timer functions to get elapsed time on a given piece of logic

function start_timer() {
  timer=$(($(print -P "%D{%s%6.}") / 1000))
}

function stop_timer() {
  if [[ $timer ]]; then
    local now=$(($(print -P "%D{%s%6.}") / 1000))
    local d_ms=$(($now - $timer))
    local d_s=$((d_ms / 1000))
    local ms=$((d_ms % 1000))
    local s=$((d_s % 60))
    local m=$(((d_s / 60) % 60))
    local h=$((d_s / 3600))

    if ((h > 0)); then
      elapsed=${h}h${m}m
    elif ((m > 0)); then
      elapsed=${m}m${s}s
    elif ((s > 9)); then
      elapsed=${s}.$(printf %03d $ms | cut -c1-2)s # 12.34s
    elif ((s > 0)); then
      elapsed=${s}.$(printf %03d $ms)s # 1.234s
    else
      elapsed=${ms}ms
    fi

    echo "$elapsed"
    unset timer
  fi
}
