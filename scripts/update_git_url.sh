#!/usr/bin/env bash

# Update the remote URL of a Git repository.
update_git_url() {
  local new_remote_url remote_url repo_name
  local local_path="$1"
  local remote_host="$2"
  local remote_style="${3:-ssh}"

  repo_name="$(basename "$local_path")"
  (
    cd "$local_path" || exit
    remote_url="$(git config --get remote.origin.url)"
    local remote_path="${remote_url#*://}"
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
}

update_git_url "$@"
unset -f update_git_url
