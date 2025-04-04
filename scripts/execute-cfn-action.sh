#!/usr/bin/env bash

execute_cfn_action() {
  local action opts params stack template
  local long_opts="action:,params:,parameter-overrides:,parameters:,stack:,stack-name:,template:,template-file:"
  local short_opts="a:p:s:t:"

  opts="$(getopt -o "$short_opts" --long "$long_opts" -- "$@")"
  eval set -- "$opts"

  while true; do
    case "$1" in
      -a|--action)
        action="$2"
        shift 2
        ;;
      -p|--params|--parameter-overrides|--parameters)
        params="$2"
        shift 2
        ;;
      -s|--stack|--stack-name)
        stack="$2"
        shift 2
        ;;
      -t|--template|--template-file)
        template="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Error: Invalid option: $1"
        return 1
        ;;
    esac
  done

  if [[ -z "$action" ]]; then
    echo "Error: Action is required. Use -a or --action to specify."
    return 1
  fi

  if [[ -z "$stack" ]]; then
    stack="$(basename "$template")"
    stack="${stack%.*}"
  fi

  if [[ -z "$template" ]]; then
    echo "Error: Template file is required. Use -t, --template, --template-file to specify."
    return 1
  fi

  case "$action" in
    delete)
      aws cloudformation delete-stack \
        --stack-name "$stack"
      ;;
    deploy)
      if [[ -n "$params" ]]; then
        aws cloudformation deploy \
          --capabilities CAPABILITY_NAMED_IAM \
          --parameter-overrides "$params" \
          --stack-name "$stack" \
          --template-file "$template"
      else
        aws cloudformation deploy \
          --capabilities CAPABILITY_NAMED_IAM \
          --stack-name "$stack" \
          --template-file "$template"
      fi
      ;;
    validate)
      aws cloudformation validate-template \
        --template-body file://"$template"
      ;;
    *)
      echo "Error: Invalid action: $action"
      return 1
      ;;
  esac
}

execute_cfn_action "$@"
