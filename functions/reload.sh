#!/usr/bin/env bash

# Cross platform way to reload the current shell environment
reload() {
  local shell_path="${SHELL:-}"

  # Ensure we have an executable shell path.
  if [[ -z "$shell_path" || ! -x "$shell_path" ]]; then
    shell_path="$(command -v zsh || command -v bash || true)"
  fi

  if [[ -z "$shell_path" || ! -x "$shell_path" ]]; then
    echo "reload: unable to determine a valid shell executable" >&2
    return 1
  fi

  TERM="${TERM:-xterm-256color}"
  exec env -i \
    HOME="$HOME" \
    USER="${USER:-}" \
    LOGNAME="${LOGNAME:-}" \
    SHELL="$shell_path" \
    TERM="$TERM" \
    "$shell_path" -l
}
