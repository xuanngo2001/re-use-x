#!/bin/bash
set -e
# Description: (Internal use only) Update re-use-x scripts in different projects.

FILE_LIST=$(find . -name '*.sh' -type f | grep -v $0)



# Update in CLD
SOURCE_DIR=$(readlink -ev .)
DESTINATION_DIR=$(readlink -ev "/media/master/github/cust-live-deb/scripts/repository/inst-min-con-xtra-re-use-x/re-use-x")
./rsync-files.sh commit "${SOURCE_DIR}" "${DESTINATION_DIR}" <(echo "${FILE_LIST}")
