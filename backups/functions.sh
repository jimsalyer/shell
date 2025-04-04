#!/usr/bin/env bash

aws_login() {
  local prompt="$1"

  echo "Getting verification code from password manager..."
  AZURE_DEFAULT_VERIFICATION_CODE="$(op item get --vault Work --otp EFM)"
  export AZURE_DEFAULT_VERIFICATION_CODE

  echo "Starting AWS login process..."
  if [[ -z "$prompt" ]]; then
    aws-azure-login --no-prompt
  else
    aws-azure-login
  fi
}

load_password() {
  if [[ ! -d "$HOME/.cache" ]]; then
    mkdir "$HOME/.cache"
  fi

  if [[ -f "$HOME/.cache/password.txt" ]]; then
    # shellcheck disable=SC2005
    echo "$(cat "$HOME"/.cache/password.txt)"
  else
    local value
    value="$(op item get --vault Work --fields label=password EFM --reveal)"
    echo "$value" > "$HOME/.cache/password.txt"
  fi
}

load_pg_password() {
  if [[ ! -d "$HOME/.cache" ]]; then
    mkdir "$HOME/.cache"
  fi

  if [[ -f "$HOME/.cache/pg-password.txt" ]]; then
    # shellcheck disable=SC2005
    echo "$(cat "$HOME"/.cache/pg-password.txt)"
  else
    local value
    value="$(op item get --vault Work --fields label=password 'EDGE PostgreSQL Cluster' --reveal)"
    echo "$value" | tr -d '"' | tr -d '\n' > "$HOME/.cache/pg-password.txt"
  fi
}

refresh_env() {
  "$HOME/shell/scripts/refresh-env.cmd"
}
