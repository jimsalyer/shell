#!/usr/bin/env bash

change_sam_version() {
  local version="$1"
  if [[ -z "$version" ]]; then
    echo "A version to set as current is required."
    return
  fi

  sudo unlink /usr/local/aws-sam-cli/current
  sudo ln -s "/usr/local/aws-sam-cli/$version" /usr/local/aws-sam-cli/current
}

docker_clean() {
  docker system prune --all --force --volumes
}

emulate_arm64() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null
}

ensure_interactive() {
  [[ -z "$PS1" ]] && return
}

fix_special_keys_linux() {
  bindkey "^[[1~" beginning-of-line
  bindkey "^[[4~" end-of-line
  bindkey "^[[3~" delete-char
}

fix_special_keys_windows() {
  bindkey "^[[H"  beginning-of-line
  bindkey "^[[F"  end-of-line
  bindkey "^[[3~" delete-char
}

flatten() {
  cd "$1" || return
  find . -mindepth 2 -type f -exec mv {} .. \;
  find . -type d -empty -delete
}

git_clean_branches() {
  git fetch -p
  git branch -vv | grep 'gone]' | awk '{print $1}' | xargs git branch -D
}

load_brew() {
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

load_dircolors() {
  local file="${1:-$HOME/.dircolors}"
  eval "$(dircolors -b "$file")"
}

load_posh() {
  eval "$(oh-my-posh init "$1" -c "$2")"
}

lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

lower_case() {
  # shellcheck disable=SC2005
  echo "$(lower "$1")"
}

npm_pack_zip() {
  local package_name
  package_name=$(jq -r '.name' package.json)
  local package_version
  package_version=$(jq -r '.version' package.json)
  local package_tarball="$package_name-$package_version.tgz"

  npm pack
  tar -xvf "$package_tarball"
  mv package "$package_name"
  zip -r "$package_name.zip" "$package_name"
  rm -fr "$package_name" "$package_tarball"
}

paths() {
  echo "$PATH" | tr ':' '\n'
}

reload() {
  local shell
  shell=$(shell)

  if [[ "$shell" == bash ]]; then
    exec bash
  elif [[ "$shell" == zsh ]]; then
    exec zsh
  fi
}

repack7() {
  local orig_nocasematch
  orig_nocasematch=$(shopt -p nocasematch; true)
  shopt -s nocasematch

  for file_path in "$@"; do
    local file_name
    file_name=$(basename -- "$file_path")
    local base_name="${file_name%%.*}"
    local ext="${file_name##*.}"

    if [[ "$ext" != "7z" ]]; then
      echo "'$file_name' is not a 7z file. Skipping to next file"
      continue
    fi

    local dir_path="${file_path%.*}"
    local zip_path="$dir_path.zip"

    echo "Repacking '$file_name'"
    if [[ -f "$zip_path" ]]; then
      echo "'$file_name' has already been repacked. Skipping to next file"
      continue
    fi

    echo "Extracting '$file_name' to temp folder"
    if [[ ! -d "$dir_path" ]]; then
      7z e -o"$dir_path" "$file_path"
    else
      echo "'$file_name' has already been extracted. Skipping to next step"
    fi

    echo "Zipping temp folder '$base_name'"
    zip -jr "$dir_path.zip" "$dir_path"

    echo "Removing temp folder '$base_name'"
    rm -fr "$dir_path"
  done

  $orig_nocasematch
}

shell() {
  # shellcheck disable=SC2005
  echo "$(basename "$SHELL")"
}

start_timer() {
  timer=$(($(date +%s%0N) / 1000000))
  echo 'Timer started'
}

stop_timer() {
  if [[ $timer ]]; then
    now=$(($(date +%s%0N) / 1000000))
    elapsed=$((now - timer))

    echo "Timer ran for ${elapsed}ms"
    unset timer
  fi
}

upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

upper_case() {
  # shellcheck disable=SC2005
  echo "$(upper "$1")"
}
