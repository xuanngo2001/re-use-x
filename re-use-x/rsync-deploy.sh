#!/bin/bash
set -e
# Description: Copy from SOURCE/ to DESTINATION/ and delete extraneous files from the receiving side.
# Usage: this_script.sh <action> <source_dir> <destination_dir> [exclude_list]
#   [exclude_list] is optional.
# Output: When commit, log file created at ./deploy_logs/deploy_2016-02-16_15.13.35.log.
script_name=$(basename "$0")

action=$1
source_dir=$2
destination_dir=$3
exclude_list=$4

exclude_from_option=""

# Error handling
  cmd_examples=$(printf " %s\n %s\n %s\n" \
                        " e.g. $0 <action> <source_dir> <destination_dir> [exclude_list]"\
                        " e.g. $0 try /some/source/ /some/destination/"\
                        " e.g. $0 commit /some/source/ /some/destination/ exclude.txt"\
                )
	if [ -z "${action}" ]; then
	  echo "$0: Error: ${script_name}: Action can't be empty. Aborted!"
	  echo "${cmd_examples}"
	  exit 1;
	fi
	
	if [ ! -d "${source_dir}" ]; then
	  echo "$0: Error: ${script_name}: Source directory: ${source_dir}: no such directory. Aborted!"
	  echo "${cmd_examples}"
	  exit 1;
	fi
	
	if [ ! -d "${destination_dir}" ]; then
	  echo "$0: Error: ${script_name}: Destination directory: ${destination_dir}: no such directory. Aborted!"
	  echo "${cmd_examples}"
	  exit 1;
	fi
	
	if [ ! -z "${exclude_list}" ]; then
		if [ ! -f "${exclude_list}" ]; then
		  echo "$0: Error: ${script_name}: Exclude list file: ${exclude_list}: no such file. Aborted!"
		  echo "${cmd_examples}"
		  exit 1;
		else
		  # Construct exclude option.
		  exclude_from_option="--exclude-from=${exclude_list}"	
		  exclude_list=$(readlink -ev "${exclude_list}")
	  fi
	fi
	
	source_dir=$(readlink -ev "${source_dir}")
	destination_dir=$(readlink -ev "${destination_dir}")


# Create deploy log directory.
  deploy_log_dir="./deploy_logs"
  mkdir -p "${deploy_log_dir}"
  deploy_log_dir=$(readlink -ev "${deploy_log_dir}")

# Deploy
  date_string=$(date +"%Y-%m-%d_%0k.%M.%S")
  case "${action}" in
    
    commit)
      # Really commit deployment. 
      rsync -a --checksum --delete-after --progress --itemize-changes --stats --out-format='%i %n %M %l' "${exclude_from_option}" "${source_dir}/" "${destination_dir}/" > "${deploy_log_dir}/deploy_${date_string}.log"
      echo "Deployment log created at ${deploy_log_dir}/deploy_${date_string}.log."
      ;;
      
    try)
      rsync -a --checksum --delete-after --progress --itemize-changes --stats --out-format='%i %n %M %l' --dry-run "${exclude_from_option}" "${source_dir}/" "${destination_dir}/"
      ;;
      
    *)
      echo "Error: ${script_name}: Unknown action: ${action}. Aborted!"
      echo "${cmd_examples}"
      exit 1
      ;;    
  esac

