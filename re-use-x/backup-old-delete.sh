#!/bin/bash
set -e
# Description: Delete old backup files.
#   -Usage: ./thiscript.sh archive_prefix delete_after_days
#           Delete backup files older than 7 days: ./thiscript.sh myBackupFile_ 7
script_name=$(basename $0)

archive_prefix=$1
del_after_days=$2

# Error handling.
  if [ "$#" -ne 2 ]; then
    echo "Error: 2 arguments are needed. Aborted!"
    echo "  ${script_name} mybackup_ days"
    exit 1;
  fi    
  if [ -z "${archive_prefix}" ]; then 
    echo "Error: ${archive_prefix}: Archive prefix can't be empty. Aborted!"
    echo "  ${script_name} mybackup_ days"
    exit 1;
  fi
  is_number_regex='^[0-9]+$'
  if ! [[ "${del_after_days}" =~ ${is_number_regex} ]] ; then
    echo "Error: ${del_after_days} is not a number. Aborted!" >&2
    echo "  ${script_name} mybackup_ days"
    exit 1;
  fi  

  archive_list=$(ls -1 "${archive_prefix}"*????-??-??.*.tar.bz2 | sort -r)
  if [ -z "${archive_list}" ]; then echo "${script_name}: No backup archive ${archive_prefix}*????-??-??.*.tar.bz2 to delete!"; exit 0; fi
  
  # Preserve the oldest and newest backup to guarantee that not all backups are deleted.
  archive_list=$(echo "${archive_list}" | tail -n +2 ) # Remove first line
  archive_list=$(echo "${archive_list}" | head -n -1 ) # Remove last line

  if [ -z "${archive_list}" ]; then echo "${script_name}: No backup archive ${archive_prefix}*????-??-??.*.tar.bz2 to delete!"; exit 0; fi

  #echo "${archive_list}"

# Delete old backup files from ${archive_list}.  
  counter=0
  while [ $counter -lt ${del_after_days} ]; do
    day_exclude=$(date --date="-${counter} days" +%Y-%m-%d)
    archive_list=$(echo "${archive_list}" | grep -vF "${day_exclude}" || true) # || true because it will exit if 'set -e' is set.
    counter=$[$counter+1]
  done  
  
  if [ -z "${archive_list}" ]; then
    echo "${script_name}: No backup archive ${archive_prefix}*????-??-??.*.tar.bz2 to delete!"
  else
    echo "Deleting backup archive: "
    echo "${archive_list}" | sed 's/^/  /'
    echo "${archive_list}"| tr \\n \\0 | xargs -0 -n1 rm -f
  fi

