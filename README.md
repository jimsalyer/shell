# Shell

Provides a collection of useful shell scripts that can be used to setup and maintain your shell environment.

## Requirements

- Bash or Zsh shell

## Usage

Include the relevant scripts in your dotfiles or scripts and use the included aliases, configurations, methods, and values as needed.

```shell
. /path/to/shell/env.sh
. /path/to/shell/functions.sh
. /path/to/shell/aliases.sh
```

You can also use `source /path/to/shell/functions.sh`.

To use the included Git configuration, you'll need to edit your existing Git configuration.

```config
[include]
  path = /path/to/shell/config/gitconfig
```
