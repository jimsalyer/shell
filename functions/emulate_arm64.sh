#!/usr/bin/env bash

# Use Docker to emulate an ARM environment for running ARM only programs/scripts/etc
emulate_arm64() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null
}
