#!/bin/bash
set -e
# Description: Add environment path to ${HOME}/.bashrc
#   -Depends on: bashrc-add.sh
script_name=$(basename "$0")

env_path=$1

# Error handling.
  if [ ! -d "${env_path}" ]; then
    echo "Error: ${script_name}: ${env_path}: no such directory. Aborted!"
    exit 1;
  fi    

# Add environment path.
  env_path=$(readlink -ev "${env_path}")
  env_path="PATH=\$PATH:${env_path}"
  bashrc-add.sh "${env_path}"
