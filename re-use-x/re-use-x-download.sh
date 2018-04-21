#!/bin/bash
set -e
# Description: Download the latest version of re-use-x scripts from github.

script_name=$(basename $0)
while IFS='' read -r script_file || [[ -n "${script_file}" ]]; do
  
  url_base=https://raw.githubusercontent.com/limelime/re-use-x/master/re-use-x
  wget -q "${url_base}/${script_file}" -O "${script_file}"
  
  echo "INFO: ${script_name}: Downloaded ${script_file}."
  
done < <( ls -1 *.sh | grep -v ${script_name})
