#!/usr/bin/env bash

# =============================================================================
# Name: npm-pack-zip.sh
# Type: Function
# Description: Create a zip file with the necessary files from a Node repo.
# Dependencies: jq, tar, zip
# =============================================================================

# shellcheck disable=SC2005

npm_pack_zip() {
  local package_name
  package_name=$(jq -r '.name' package.json)
  local package_version
  package_version=$(jq -r '.version' package.json)
  local package_tarball="$package_name-$package_version.tgz"

  npm pack
  tar -xvf "$package_tarball"
  mv package "$package_name"
  zip -r "$package_name.zip" "$package_name"
  rm -fr "$package_name" "$package_tarball"
}
