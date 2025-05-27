#!/bin/bash
set -e
# Description: XXXX
#  Note: Ensure that parent path of $web_root_dir are executable by Apache. http://stackoverflow.com/a/7381474
#       e.g.: chmod 755 /root /root/site /root/site/about
script_name=$(basename $0)

webroot_dir=$1
apache_symbolic_name=$2

# Error handling
  if [ $# -ne 2 ]; then
    echo "Error: ${script_name}: Missing arguments. Aborted!"
    echo "   e.g.: ${script_name}  webroot_dir apache_symbolic_name"
    echo "   e.g.: ${script_name}  /path/to/drupal/ opw"
    exit 1;
  fi
  
  if [ ! -d ${webroot_dir} ]; then
    echo "Error: ${script_name}: ${webroot_dir} is not a directory."
    exit 1;
  fi
  webroot_dir=$(readlink -ev "${webroot_dir}")

  if [[ ${apache_symbolic_name} == *"/"* ]]; then
    echo "Error: ${script_name}: apache_symbolic_name: ${apache_symbolic_name} can't be a path."
    exit 1;
  fi
    
# Link apache to folder
  apache_dir=/var/www/html/${apache_symbolic_name}
  rm -f ${apache_dir}
  ln -s ${webroot_dir} ${apache_dir}
  chown -R www-data:www-data ${webroot_dir}
  chmod -R 755 ${webroot_dir}

# Display symbolic links
  echo "INFO: ${script_name}: Linked ${apache_symbolic_name} -> ${webroot_dir}"    
