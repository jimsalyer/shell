aws_invoke() {
  local function_name="$1"
  local payload="${2:-{}}"
  local outfile="${3:-out.txt}"

  aws lambda invoke --function-name "$function_name" --payload "$payload" --cli-binary-format raw-in-base64-out --endpoint-url http://127.0.0.1:3001 --no-verify-ssl "$outfile"
}

change_sam_version() {
  local version="$1"
  if [[ ! -n "$version" ]]; then
    echo "A version to set as current is required."
    return
  fi

  sudo unlink /usr/local/aws-sam-cli/current
  sudo ln -s "/usr/local/aws-sam-cli/$version" /usr/local/aws-sam-cli/current
}

config_devtoolset() {
  export PATH="/opt/rh/devtoolset-8/root/usr/bin:$PATH"
}

config_volta() {
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
}

docker_clean() {
  docker system prune --all --force --volumes
}

emulate_arm64() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null
}

ensure_interactive() {
  if [[ -z "$PS1" ]]; then
    return
  fi
}

load_basher() {
  export PATH="$HOME/.basher/libexec:$PATH"
  eval "$(basher init - bash)"
}

load_dircolors() {
  local file="${1:-$HOME/.dircolors}"
  eval "$(dircolors -b $file)"
}

load_dnvm() {
  if [ -f "$HOME/.local/share/dnvm/env" ]; then
    . "$HOME/.local/share/dnvm/env"
  fi
}

load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

load_nvm_cloud9() {
  [ "$BASH_VERESION" ] && npm() {
    if [ "$*" == "config get prefix" ]
    then
      which node | sed "s/bin\/node//"
    else
      $(which npm) "$@"
    fi
  }

  load_nvm
  rvm_silence_path_mismatch_check_flag=1
  unset npm
}

load_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

  if [[ -z "$PYENV_VERSION" ]]; then
    export PYENV_VERSION="$(pyenv global)"
  fi
}

load_rvm() {
  [[ -s "$HOME/.rvm/environments/default" ]] && source "$HOME/.rvm/environments/default"
  export PATH="$PATH:$HOME/.rvm/bin"
}

load_sdkman() {
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}

load_zsh() {
  if [ -t 1 ]; then
    exec zsh
  fi
}

npm_pack_zip() {
  local package_name=$(jq -r '.name' package.json)
  local package_version=$(jq -r '.version' package.json)
  local package_tarball="$package_name-$package_version.tgz"

  npm pack
  tar -fvx "$package_tarball"
  mv package "$package_name"
  zip -r "$package_name.zip" "$package_name"
  rm -fr "$package_name" "$package_tarball"
}

reload() {
  case "$(shell)" in
    bash) exec bash ;;
    zsh)  exec zsh ;;
    *)    exit 1 ;;
  esac
}

sam_build_invoke() {
  emulate_arm64
  sam build
  sam_invoke_shared "$@"
}

sam_invoke() {
  emulate_arm64
  sam_invoke_shared "$@"
}

sam_invoke_shared() {
  local function_name="$1"
  local event="$2"
  local debug="$3"
  local command="sam local invoke $function_name"

  if [[ ! -z "$event" ]]; then
    if [[ "$event" == *{* ]]; then
      command="echo '$event' | $command -e '-'"
    else
      command="$command -e $event"
    fi
  fi

  if [[ ! -z "$debug" ]]; then
    command="$command --debug"
  fi

  command="$command 2>&1 | tr '\r' '\n'"
  eval "$command"
}

sam_start() {
  local warm_containers="$1"
  if [[ ! -z "$warm_containers" ]]; then
    warm_containers="${warm_containers^^}"
    sam local start-lambda --warm-containers "$warm_containers"
  else
    sam local start-lambda
  fi
}

shell() {
  echo "$(readlink /proc/$$/exe | sed "s/.*\///")"
}
