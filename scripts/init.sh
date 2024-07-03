#!/usr/bin/env bash

init_mac() {
  export APP_SUPPORT="/Library/Application Support"
  export HOME_APP_SUPPORT="$HOME/Library/Application Support"
}

init_aliases() {
  alias chx="chmod +x"
  alias cl=clear
  alias ls="ls -Fah --color=auto"
  alias paths="echo $PATH | tr ':' '\n'"
  alias reload="exec zsh"
  alias rl=reload
  alias rs=reset
}

init_brew() {
  export HOMEBREW_BIN="/opt/homebrew/bin"
  export HOMEBREW_OPT="/opt/homebrew/opt"
  eval "$($HOMEBREW_BIN/brew shellenv)"
}

# Dependencies: init_brew
init_coreutils_brew() {
  export PATH="$HOMEBREW_OPT/coreutils/libexec/gnubin:$PATH"
}

# Dependencies: init_mac
init_dnvm_mac() {
  [[ -f "$HOME_APP_SUPPORT/dnvm/env" ]] && source "$HOME_APP_SUPPORT/dnvm/env"
}

# Dependencies: init_coreutils (Mac OS only)
init_dracula() {
  source ~/dracula/zsh/dracula.zsh-theme
  eval "$(dircolors ~/dracula/dircolors/.dircolors)"
}

init_dracula_zsh() {
  init_dracula_common
  [[ ! "$(grep -i dracula ~/.gitconfig)" ]] && ((echo ""; cat ~/dracula/git/config/gitconfig) >> ~/.gitconfig)
}

init_fnm() {
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

# Dependencies: init
init_netskope_mac() {
  local netskope_cert_bundle="$APP_SUPPORT/Netskope/STAgent/data/netskope-cert-bundle.pem"
  export AWS_CA_BUNDLE="$netskope_cert_bundle"
  export CURL_CA_BUNDLE="$netskope_cert_bundle"
  export NODE_EXTRA_CA_CERTS="$netskope_cert_bundle"
  export SSL_CERT_FILE="$netskope_cert_bundle"
  export GIT_SSL_CAPATH="$netskope_cert_bundle"
  export REQUESTS_CA_BUNDLE="$netskope_cert_bundle"
}

init_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" # This loads nvm
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

# Dependencies: init_brew
init_nvm_brew() {
  export NVM_DIR="$HOME/.nvm"
  local homebrew_nvm="$HOMEBREW_OPT/nvm"
  [[ -s "$homebrew_nvm/nvm.sh" ]] && source "$homebrew_nvm/nvm.sh" # This loads nvm
  [[ -s "$homebrew_nvm/etc/bash_completion.d/nvm" ]] && source "$homebrew_nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
}

init_nvm_hack() {
  # load NVM
  export NVM_DIR="$HOME/.nvm"
  [[ "$BASH_VERSION" ]] && npm() {
      # Hack: Avoid slow NPM sanity check in NVM
      if [[ "$*" == "config get prefix" ]]; then
        which node | sed "s/bin\/node//"
      else
        $(which npm) "$@"
      fi
  }

  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"  # This loads NVM
  rvm_silence_path_mismatch_check_flag=1 # Prevent RVM complaints that NVM is first in PATH
  unset npm # End hack
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads NVM bash_completion
}

init_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
}

init_rbenv() {
  eval "$(rbenv init - zsh)"
}

# Dependencies: init_brew
init_sdkman_brew() {
  local sdkman_exec="$HOMEBREW_OPT/sdkman-cli/libexec"
  [[ -s "$sdkman_exec/sdkman-init.sh" ]] && source "$sdkman_exec/sdkman-init.sh"
}

# Dependencies: init_brew
init_sqlite_brew() {
  local sqlite_dir="$HOMEBREW_OPT/sqlite"
  export PATH="$sqlite_dir/bin:$PATH"
  export LDFLAGS="-L$sqlite_dir/lib"
  export CPPFLAGS="-I$sqlite_dir/include"
}

init_ssh() {
  local env=~/.ssh/agent.env

  # Load environment file
  [[ -f "$env" ]] && source $env >| /dev/null

  # Get agent run state:
  # 0 = agent running with keys
  # 1 = agent running without keys
  # 2 = agent not running
  state=$(
    ssh-add -l >| /dev/null 2>&1
    echo $?
  )

  if [[ ! "$SSH_AUTH_SOCK" ]] || [[ "$state" == 2 ]]; then
    # If the agent is not running, start it
    umask 077
    ssh-agent >| $env
    source $env >| /dev/null
  fi

  private_keys=("$@")
  public_keys=$(ssh-add -L)

  # Add any SSH keys that haven't been added yet
  for private_key in $private_keys; do
    public_key="$(cat ~/.ssh/$private_key.pub)"
    if [[ $public_keys != *$public_key* ]]; then
      ssh-add ~/.ssh/$private_key
    fi
  done
}

init_volta() {
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
}
