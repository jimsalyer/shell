config_volta() {
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
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

load_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

  if [[ -z "$PYENV_VERSION" ]]; then
    export PYENV_VERSION="$(pyenv global)"
  fi
}

load_sdkman() {
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
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

shell() {
  echo "$(readlink /proc/$$/exe | sed "s/.*\///")"
}
