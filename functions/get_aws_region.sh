#!/usr/bin/env bash

get_aws_region() {
  if [[ -n "$AWS_REGION" ]]; then
    echo "$AWS_REGION"
    return 0
  elif [[ -n "$AWS_DEFAULT_REGION" ]]; then
    echo "$AWS_DEFAULT_REGION"
    return 0
  elif [[ -n "$AWS_CONFIG_REGION" ]]; then
    echo "$AWS_CONFIG_REGION"
    return 0
  elif [[ -n "$AWS_EC2_REGION" ]]; then
    echo "$AWS_EC2_REGION"
    return 0
  fi

  echo "AWS region not set. Getting from current configuration..." >&2
  AWS_CONFIG_REGION="$(aws configure get region)"

  if [[ -n "$AWS_CONFIG_REGION" ]]; then
    export AWS_CONFIG_REGION
    echo "$AWS_CONFIG_REGION"
    return 0
  fi

  echo "AWS region not configured. Getting from EC2..." >&2
  AWS_EC2_REGION="$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].RegionName')"

  if [[ -n "$AWS_EC2_REGION" ]]; then
    export AWS_EC2_REGION
    echo "$AWS_EC2_REGION"
    return 0
  fi

  echo "AWS region not available." >&2
  return 1
}
