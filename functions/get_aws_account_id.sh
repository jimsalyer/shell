#!/usr/bin/env bash

get_aws_account_id() {
  if [[ -z "$AWS_ACCOUNT_ID" ]]; then
    echo "AWS account ID not set. Retrieving..."
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
  fi

  export AWS_ACCOUNT_ID
  echo "$AWS_ACCOUNT_ID"
}
