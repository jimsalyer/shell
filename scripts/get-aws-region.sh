#!/usr/bin/env bash

get_aws_region() {
  if [[ -z "$AWS_REGION" ]]; then
    echo "AWS region not set. Retrieving..."
    AWS_REGION=$(aws configure get region)
  fi

  export AWS_REGION
  echo "$AWS_REGION"
}
