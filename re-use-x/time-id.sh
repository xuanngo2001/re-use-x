#!/bin/bash
set -e
# Description: Return time identifier.

  type=$1
  type=$( echo "${type}" | tr '[:upper:]' '[:lower:]' )

  id=""
  time_str=$(date '+%H:%M:%S')
  hours=$(echo $time_str | cut -d':' -f1 | sed 's/^0//')
  minutes=$(echo $time_str | cut -d':' -f2 | sed 's/^0//')
  seconds=$(echo $time_str | cut -d':' -f3 | sed 's/^0//')
  seconds_since_midnight=""
  seconds_since_midnight=$(( ($hours*60 + $minutes)*60 + $seconds ))
  seconds_since_midnight=$(printf "%05d" ${seconds_since_midnight})  
    
  case "${type}" in
      sec-short)
        id=$(date +"%Y%m%d.")${seconds_since_midnight}
        ;;
      sec-medium)
        id=$(date +"%Y-%m-%d.")${seconds_since_midnight}
        ;;
      sec-long)
        id=$(date +"%Y-%m-%d.%0k.%M.%S")
        ;;
      sec-full)
        id=$(date +"%Y%m%d%0k%M%S")
        ;;
      *)
        echo "ERROR: $(basename $0): ${type} is an unknown type. Aborted!"
        exit 1;
  esac
  
  echo "${id}" 


#function func_id_options()
#{ 
#  types=(sec-short sec-medium sec-long)
#  types+=(sec-full)
#  
#  printf "%-10s  %-6s %-25s\n" 'Type' 'Length' 'Output'
#  echo "============================="
#  for type in "${types[@]}"
#  do
#    id_result=$( func_id "${type}")
#    printf "%-10s  %-6s %-25s\n" "${type}" "${#id_result}" "${id_result}" 
#  done  
#}  
