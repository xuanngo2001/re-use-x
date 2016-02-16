#!/bin/bash
set -e
# Description: Setup Apache.

WEB_ROOT_DIR=$1
APACHE_SYMBOLIC_NAME=$2

# Error handling
##################
if [ $# -ne 2 ]; then
	echo "$0: Error: Missing arguments. Aborted!"
	echo "   e.g.: $0  WEB_ROOT_DIR APACHE_SYMBOLIC_NAME"
	echo "   e.g.: $0  /path/to/drupal/ opw"
	exit 1;
fi

if [ ! -d ${WEB_ROOT_DIR} ]; then
  echo "$0: Error: ${WEB_ROOT_DIR} is not a directory."
  exit 1;
fi

WEB_ROOT_DIR=$(readlink -ev "${WEB_ROOT_DIR}")

# Link apache to folder
##################
APACHE_DIR=/var/www/html/${APACHE_SYMBOLIC_NAME}
rm -f ${APACHE_DIR}
ln -s ${WEB_ROOT_DIR} ${APACHE_DIR}
chmod -R 777 ${WEB_ROOT_DIR}

# Display symbolic links
#########################
echo "$0: $(ls -l /var/www/html/ | grep ${APACHE_SYMBOLIC_NAME})"