#!/usr/bin/env bash
set -e

#export MINION_NAME=M5KVK
#export FOLDER_SECRET=xxx
#export MASTER_IP=172.29.12.178

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi


# Verify that all the required varibles are set before starting up the application.

echo "Verifying settings..."
echo " "
sleep 2

missing_variables=false
        
# Begin defining all the required configuration variables.

[ -z "$MINION_NAME" ] && echo "Minion name is missing, will abort startup." && missing_variables=true || echo "Minion name is set: $MINION_NAME"
[ -z "$FOLDER_SECRET" ] && echo "Resilio Sync folder secret is missing, will abort startup." && missing_variables=true || echo "Folder sync secret is set: $FOLDER_SECRET"
[ -z "$MASTER_IP" ] && echo "Master IP Address is missing, will abort startup." && missing_variables=true || echo "Folder sync secret is set: $MASTER_IP"

# End defining all the required configuration variables.

echo " "

if [ "$missing_variables" = true ]
then
        echo "Settings missing, aborting..."
        echo " "
        sleep infinity
fi

echo "Settings verified, proceeding with startup."
echo " "

# Variables are verified – continue with startup procedure.

# Edit /mnt/sync/config.sync to include variables

cd /mnt/sync
cp /tmp/config.sync .

ls -l

sed -i 's/MINION_NAME/'"${MINION_NAME}"'/;s/FOLDER_SECRET/'"${FOLDER_SECRET}"'/;s/MASTER_IP/'"${MASTER_IP}"'/' config.sync

# create the sync directory
mkdir -p /mnt/data/mlat

# Execute sync with a default config

/usr/bin/rslsync --nodaemon --config /mnt/sync/config.sync
