#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

# Convert JSON files to CSV files for easy importing and editing.

SCRIPT_PATH="$(dirname "$0")"

source "$SCRIPT_PATH/exit-script.sh"
source "$SCRIPT_PATH/get-file-extension.sh"
source "$SCRIPT_PATH/get-file-name.sh"
source "$SCRIPT_PATH/get-file-path.sh"
source "$SCRIPT_PATH/to-lowercase.sh"

json_file="$1"
if [[ -z "$json_file" ]]; then
  echo "A JSON input file is required."
  exit_script
fi

json_path="$(get_file_path "$json_file" true)"
json_name="$(get_file_name "$json_file")"
json_extension="$(get_file_extension "$json_file")"
json_file="$json_name.$json_extension"
json_full_path="$json_path$json_file"

if [[ "$(to_lower "$json_extension")" != json ]]; then
  echo "Input file must be JSON."
  exit_script
elif [[ ! -f "$json_full_path" ]]; then
  echo "\"$json_full_path\" does not exist."
  exit_script
fi

csv_file="$2"
if [[ -z "$csv_file" ]]; then
  echo "No CSV output file was provided. Using JSON input file name and path."
  csv_file="$json_path$json_name.csv"
fi

csv_path="$(get_file_path "$csv_file" true)"
csv_name="$(get_file_name "$csv_file")"
csv_extension="$(get_file_extension "$csv_file")"
csv_file="$csv_name.$csv_extension"
csv_full_path="$csv_path$csv_file"

if [[ "$(to_lower "$csv_extension")" != csv ]]; then
  echo "Output file must be CSV."
  exit_script
fi

jq -r \
  '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' \
  "$json_full_path" \
  > "$csv_full_path"

echo "Successfully converted \"$json_file\" to \"$csv_file\"."
