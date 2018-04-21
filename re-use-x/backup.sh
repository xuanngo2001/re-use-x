# Description: Backup target_dir path.
#   -Depends on: time-id.sh

target_dir=$1

# Error handling.  
  if [ ! -e "${target_dir}" ]; then
    echo "Error: ${target_dir}: no such file or directory. Aborted!"
    echo "  $0 FILE_OR_DIRECTORY"
    exit 1;
  fi
  target_dir=$(readlink -ev "${target_dir}")
  
# Backup
  date_string=$(time-id.sh sec-medium)
  target_parent_dir_path="$(dirname "${target_dir}")"
  target_dir_name="$(basename "${target_dir}")"
  output_archive="${target_parent_dir_path}/${target_dir_name}_${date_string}.tar.bz2"
  
  tar -jcf "${output_archive}" -C "${target_parent_dir_path}" "${target_dir_name}"
  # List content: tar -tvf archive.tar.bz2
  # Extract content: tar -xvjf archive.tar.bz2
  
  echo "Backup to: ${output_archive}"

