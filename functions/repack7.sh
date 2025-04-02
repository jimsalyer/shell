#!/usr/bin/env bash

# =============================================================================
# Name: repack7.sh
# Type: Function
# Description: Repack a 7z file as a zip file.
# Dependencies: 7z, zip
# =============================================================================

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
