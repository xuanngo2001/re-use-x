#!/bin/bash
set -e
# Description: Create soft symbolic link: target_name -> link_name
# Warning: link_name will be destroyed.
script_name=$(basename "$0")
 
target_name=$1
link_name=$2

# Error handling.
  if [ $# -ne 2 ]; then
    echo "Error: Missing arguments. Aborted!"
    echo "  ${script_name} target_name link_name"
    echo "  ${script_name} /backup/data/google-chrome  /root/.config/google-chrome"
    exit 1;
  fi

# Copy original ${link_name} if ${target_name} doesn't exist.
  if [ ! -e "${target_name}" ]; then
    if [ -e "${link_name}" ]; then
      cp -av "${link_name}" "${target_name}"
    fi
  fi
  
# Link
  target_name=$(readlink -ev "${target_name}") &&  rm -rf "${link_name}"
  ln -s "${target_name}" "${link_name}"
  ls -l "${link_name}"  
