#!/usr/bin/env bash

# =============================================================================
# Name: emulate-arm64.sh
# Type: Function
# Description: Use Docker to emulate an ARM environment for running ARM only
#              programs/scripts/etc.
# Dependencies: docker
# =============================================================================

emulate_arm64() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null
}
