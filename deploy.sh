#!/bin/bash
set -e
# Description: Copy from SOURCE/ to DESTINATION/ and delete extraneous files from the receiving side. 

SOURCE_DIR="."
DEST_DIR=/media/sf_shared/firstboot

# Error handling
if [ ! -d "${SOURCE_DIR}" ]; then
  echo "$0: Error: Source directory: ${SOURCE_DIR}: no such directory. Aborted!"
  exit 1;
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "$0: Error: Destination directory: ${DEST_DIR}: no such directory. Aborted!"
  exit 1;
fi

SOURCE_DIR=$(readlink -ev "${SOURCE_DIR}")
DEST_DIR=$(readlink -ev "${DEST_DIR}")


# Copy list of files from SOURCE/ to DESTINATION/.
EXCLUDE_LIST="deploy-exclude.txt"

# Create deploy log directory.
DEPLOY_LOG_DIR="./deploy_logs"
mkdir -p "${DEPLOY_LOG_DIR}"
DEPLOY_LOG_DIR=$(readlink -ev "${DEPLOY_LOG_DIR}")

# Deploy
DATE_STRING=$(date +"%Y-%m-%d_%0k.%M.%S")
ACTION=$1
case "${ACTION}" in
  
  commit)
    # Really commit deployment. 
    rsync -a --checksum --delete-after --progress --itemize-changes --stats --out-format='%t %p %i %n %M %l' --exclude-from="${EXCLUDE_LIST}" "${SOURCE_DIR}/" "${DEST_DIR}/" > "${DEPLOY_LOG_DIR}/deploy_${DATE_STRING}.log"
    ;;
    
  *)
    rsync -a --checksum --delete-after --progress --itemize-changes --stats --out-format='%t %p %i %n %M %l' --dry-run --exclude-from="${EXCLUDE_LIST}" "${SOURCE_DIR}/" "${DEST_DIR}/" > "${DEPLOY_LOG_DIR}/deploy_${DATE_STRING}.log"
    ;;
esac

echo "Deployment log created at ${DEPLOY_LOG_DIR}/deploy_${DATE_STRING}.log."