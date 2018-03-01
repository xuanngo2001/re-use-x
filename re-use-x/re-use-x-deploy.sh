#!/bin/bash
set -e
# Description: Deploy re-use-x scripts.
#   TODO: Deal with different file versions.

# While loop.
  while IFS='' read -r script_file || [[ -n "${script_file}" ]]; do
    path_found=$(whereis ${script_file} | cut -d ':' -f 2 | xargs)
    if [ -z "${path_found}" ]; then
      cp -av ${script_file} /usr/local/bin
    fi
  done < <( ls -1 *.sh )
