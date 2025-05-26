#!/bin/bash
set -e
# Description: Add unique entry in ${HOME}/.bashrc

line="$1"
if ! grep -q "${line}" ${HOME}/.bashrc
then
  echo "${line}" >> ${HOME}/.bashrc
  source ${HOME}/.bashrc
  echo "~/.bashrc: Added: ${line}."
fi  
