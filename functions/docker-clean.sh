#!/usr/bin/env bash

# =============================================================================
# Name: docker-clean.sh
# Type: Function
# Description: Clean up Docker's cache and unused images.
# Dependencies: docker
# =============================================================================

docker_clean() {
  docker system prune -f --volumes
}

docker_clean_all() {
  docker system prune -af --volumes
}
