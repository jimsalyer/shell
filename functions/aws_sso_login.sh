#!/usr/bin/env bash

aws_sso_login() {
  # If no profile was provided, get it from the environment and trigger the SSO login.
  local profile="${1:-"$AWS_PROFILE"}"
  aws sso login --profile "$profile"

  # Export the current credentials in environment format (no export statements).
  local creds
  creds="$(aws configure export-credentials --profile "$profile" --format env-no-export)"

  # Grab each value from the exported credentials.
  local key secret token
  key="$(echo "$creds" | grep AWS_ACCESS_KEY_ID | sed 's/^AWS_ACCESS_KEY_ID=//')"
  secret="$(echo "$creds" | grep AWS_SECRET_ACCESS_KEY | sed 's/^AWS_SECRET_ACCESS_KEY=//')"
  token="$(echo "$creds" | grep AWS_SESSION_TOKEN | sed 's/^AWS_SESSION_TOKEN=//')"

  # Set the current session's values explicitly using the exported values.
  aws configure set aws_access_key_id "$key" --profile "$profile"
  aws configure set aws_secret_access_key "$secret" --profile "$profile"
  aws configure set aws_session_token "$token" --profile "$profile"
  echo "AWS credentials synced"
}
