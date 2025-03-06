#!/usr/bin/env bash

# =============================================================================
# Name: change-sam-version.sh
# Type: Function
# Description: Switch between multiple versions of AWS SAM CLI.
# Dependencies: AWS SAM CLI
# =============================================================================

change_sam_version() {
  local version="$1"
  if [[ -z "$version" ]]; then
    echo "A version to set as current is required."
    return
  fi

  sudo unlink /usr/local/aws-sam-cli/current
  sudo ln -s "/usr/local/aws-sam-cli/$version" /usr/local/aws-sam-cli/current
}
