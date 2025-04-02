#!/usr/bin/env bash

# =============================================================================
# Name: update-git-url.sh
# Type: Script
# Description: Update the remote URL of a Git repository.
# Dependencies: git
# =============================================================================

local_path="$1"
remote_host="$2"
remote_style="${3:-ssh}"

repo_name="$(basename "$local_path")"
(
  cd "$local_path" || exit
  remote_url="$(git config --get remote.origin.url)"
  remote_path="${remote_url#*://}"
  remote_path="${remote_path#*/}"

  if [[ "$remote_style" == "ssh" ]]; then
    new_remote_url="git@$remote_host:$remote_path"
  else
    new_remote_url="https://$remote_host/$remote_path"
  fi

  echo "Updating remote URL for repository \"$repo_name\" to \"$new_remote_url\"..."
  git remote set-url origin "$new_remote_url"
  echo "Checking remote URL change for repository \"$repo_name\"..."
  git pull > /dev/null 2>&1
)
