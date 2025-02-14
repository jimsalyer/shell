#!/usr/bin/env bash

# =============================================================================
# Name: load-homebrew.sh
# Type: Function
# Description: Initialize the Homebrew shell environment no matter which
#              platform it's installed on.
# =============================================================================

load_homebrew() {
  local brew_path
  if [[ -d /opt/homebrew ]]; then
    brew_path=/opt/homebrew/bin/brew
  elif [[ -d /usr/local/homebrew ]]; then
    brew_path=/usr/local/homebrew/bin/brew
  elif [[ -d "$HOME/.linuxbrew" ]]; then
    brew_path="$HOME/.linuxbrew/bin/brew"
  elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    brew_path=/home/linuxbrew/.linuxbrew/bin/brew
  fi
  [[ "$brew_path" ]] && eval "$($brew_path shellenv)"
}

load_brew() {
  load_homebrew
}
