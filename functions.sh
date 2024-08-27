aws_invoke() {
  local function_name="$1"
  local payload="${2:-{}}"
  local outfile="${3:-out.txt}"

  aws lambda invoke --function-name "$function_name" --payload "$payload" --cli-binary-format raw-in-base64-out --endpoint-url http://127.0.0.1:3001 --no-verify-ssl "$outfile"
}

# Dependencies: config_posh
change_posh_theme() {
  export POSH_THEME="$POSH_THEMES_PATH/$1.omp.json"
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

# Dependencies: load_brew
config_coreutils_brew() {
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
}

config_devtoolset() {
  export PATH="/opt/rh/devtoolset-8/root/usr/bin:$PATH"
}

config_mac() {
  export APP_SUPPORT="/Library/Application Support"
  export HOME_APP_SUPPORT="$HOME/Library/Application Support"
}

# Dependencies: config_mac
config_netskope_mac() {
  local netskope_cert_bundle="$APP_SUPPORT/Netskope/STAgent/data/netskope-cert-bundle.pem"
  export AWS_CA_BUNDLE="$netskope_cert_bundle"
  export CURL_CA_BUNDLE="$netskope_cert_bundle"
  export NODE_EXTRA_CA_CERTS="$netskope_cert_bundle"
  export SSL_CERT_FILE="$netskope_cert_bundle"
  export GIT_SSL_CAPATH="$netskope_cert_bundle"
  export REQUESTS_CA_BUNDLE="$netskope_cert_bundle"
}

config_posh() {
  export POSH_THEMES_PATH="$(brew --prefix oh-my-posh)/themes"
}

# Dependencies: load_brew
config_sqlite_brew() {
  local sqlite_dir="$(brew --prefix sqlite)"
  export PATH="$sqlite_dir/bin:$PATH"
  export LDFLAGS="-L$sqlite_dir/lib"
  export CPPFLAGS="-I$sqlite_dir/include"
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

fix_special_keys_linux() {
  bindkey "^[[1~" beginning-of-line
  bindkey "^[[4~" end-of-line
  bindkey "^[[3~" delete-char
}

fix_special_keys_windows() {
  bindkey "^[[H"  beginning-of-line
  bindkey "^[[F"  end-of-line
  bindkey "^[[3~" delete-char
}

flatten() {
  cd "$1"
  find . -mindepth 2 -type f -exec mv {} .. \
  find . -type d -empty -delete
}

load_brew() {
  local brew_path
  if [[ -d /opt/homebrew ]]; then
    brew_path=/opt/homebrew/bin/brew
  elif [[ -d /usr/local/homebrew ]]; then
    brew_path=/usr/local/homebrew/bin/brew
  elif [[ -d "$HOME/.linuxbrew" ]]; then
    brew_path="$HOME/.linuxbrew/bin/brew"
  elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    brew_path=/home/linuxbrew/.linuxbrew/bin/brew
  fi
  [[ "$brew_path" ]] && eval "$($brew_path shellenv)"
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

# Dependencies: config_mac
load_dnvm_mac() {
  [[ -f "$HOME_APP_SUPPORT/dnvm/env" ]] && source "$HOME_APP_SUPPORT/dnvm/env"
}

# Dependencies: config_mac
load_fnm_mac() {
  export PATH="$HOME/.local/state/fnm_multishells/46415_1719956937051/bin:$PATH"
  export FNM_DIR="$HOME_APP_SUPPORT/fnm"
  export FNM_RESOLVE_ENGINES="false"
  export FNM_COREPACK_ENABLED="false"
  export FNM_MULTISHELL_PATH="$HOME/.local/state/fnm_multishells/46415_1719956937051"
  export FNM_LOGLEVEL="info"
  export FNM_VERSION_FILE_STRATEGY="local"
  export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
  export FNM_ARCH="arm64"
  rehash
}

load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

# Dependencies: load_brew
load_nvm_brew() {
  export NVM_DIR="$HOME/.nvm"
  local homebrew_nvm="$(brew --prefix nvm)"
  [[ -s "$homebrew_nvm/nvm.sh" ]] && source "$homebrew_nvm/nvm.sh" # This loads nvm
  [[ -s "$homebrew_nvm/etc/bash_completion.d/nvm" ]] && source "$homebrew_nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
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

load_posh() {
  local shell="$1"
  local theme="$POSH_THEMES_PATH/$2.omp.json"
  eval "$(oh-my-posh --init --shell $shell --config $theme)"
}

load_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

  if [[ -z "$PYENV_VERSION" ]]; then
    export PYENV_VERSION="$(pyenv global)"
  fi
}

load_rbenv() {
  eval "$(rbenv init - zsh)"
}

load_rvm() {
  [[ -s "$HOME/.rvm/environments/default" ]] && source "$HOME/.rvm/environments/default"
  export PATH="$PATH:$HOME/.rvm/bin"
}

load_sdkman() {
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}

# Dependencies: load_brew
load_sdkman_brew() {
  export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
}

load_zsh() {
  if [ -t 1 ]; then
    exec zsh
  fi
}

lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

lower_case() {
  echo "$(lower $1)"
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
  local shell="$(shell)"
  if [[ "$shell" == bash ]]; then
    exec bash
  elif [[ "$shell" == zsh ]]; then
    exec zsh
  fi
}

repack7() {
  local orig_nocasematch=$(shopt -p nocasematch; true)
  shopt -s nocasematch

  for file_path in "$@"; do
    local file_name=$(basename -- "$file_path")
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
  echo "$(basename $SHELL)"
}

start_timer() {
  timer=$(($(gdate +%s%0N) / 1000000))
  echo 'Timer started'
}

stop_timer() {
  if [ $timer ]; then
    now=$(($(gdate +%s%0N) / 1000000))
    elapsed=$(($now - $timer))

    echo "Timer ran for ${elapsed}ms"
    unset timer
  fi
}

upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

upper_case() {
  echo "$(upper $1)"
}
