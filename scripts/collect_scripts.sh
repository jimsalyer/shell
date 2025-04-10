#!/usr/bin/env bash

# Collect scripts into a single file.

collect_scripts() {
  local output_file="scripts.sh"
  local shell_type="bash"
  local args output_file_extension output_file_name shell_checks

  args="$(getopt -o 'c:o:s:' -l 'checks:,shellchecks:,shell-checks:,output:,output-file:,shell:,shell-type:' -n 'collect_scripts' -- "$@")"
  eval set -- "$args"

  while true; do
    case "$1" in
      -c | --checks | --shellchecks | --shell-checks)
        shift
        shell_checks="$1"
        ;;
      -o | --output | --output-file)
        shift
        output_file="$1"
        ;;
      -s | --shell | --shell-type)
        shift
        shell_type="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
        ;;
      --)
        shift
        break
        ;;
    esac
    shift
  done

  if [[ ! "$shell_type" =~ ^(bash|csh|fish|sh|zsh)$ ]]; then
    echo "Invalid shell type: $shell_type" >&2
    return 1
  fi

  output_file_name="$(basename "$output_file")"
  output_file_extension="$(echo "${output_file_name##*.}" | tr '[:upper:]' '[:lower:]')"

  if [[ ! "$output_file_extension" =~ ^(bash|csh|fish|sh|zsh)$ ]]; then
    echo "Invalid output file: $output_file_name" >&2
    return 1
  fi

  echo "Initializing $output_file_name..."
  echo "#!/usr/bin/env $shell_type" > "$output_file"
  echo >> "$output_file"

  if [[ -n "$shell_checks" ]]; then
    echo "Adding shell checks to $output_file_name..."
    echo "# shellcheck disable=$shell_checks" >> "$output_file"
    echo >> "$output_file"
  fi

  for file in "$@"; do
    local file_content file_extension file_name

    file_name="$(basename "$file")"
    file_extension="$(echo "${file_name##*.}" | tr '[:upper:]' '[:lower:]')"

    if [[ "$file_extension" != "$output_file_extension" ]]; then
      echo "Invalid file: $file_name" >&2
      return 1
    fi

    echo "Adding $file_name to $output_file_name..."
    file_content="$( (sed 's/^#!.*//g' | sed 's/^#.*//g' | awk 'BEGIN{RS="";ORS="\n\n"}1') < "$file")"
    echo "$file_content" >> "$output_file"
    echo >> "$output_file"
  done
}

collect_scripts "$@"
unset -f collect_scripts
