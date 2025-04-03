#!/usr/bin/env bash

execute_cfn_action() {
  local stack_name
  local action="$1"
  local template_file="$2"
  local parameter_overrides="$3"

  stack_name="$(basename "$template_file")"
  stack_name="${stack_name%.*}-stack"

  case "$action" in
    delete)
      aws cloudformation delete-stack \
        --stack-name "$stack_name"
      ;;
    deploy)
      if [[ -n "$parameter_overrides" ]]; then
        aws cloudformation deploy \
          --capabilities CAPABILITY_NAMED_IAM \
          --parameter-overrides "$parameter_overrides" \
          --stack-name "$stack_name" \
          --template-file "$template_file"
      else
        aws cloudformation deploy \
          --capabilities CAPABILITY_NAMED_IAM \
          --stack-name "$stack_name" \
          --template-file "$template_file"
      fi
      ;;
    validate)
      aws cloudformation validate-template \
        --template-body file://"$template_file"
      ;;
  esac
}

execute_cfn_action "$@"
