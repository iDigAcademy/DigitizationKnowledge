#!/bin/bash

. "../environment.sh"

echo "Copying supervisor conf files..."
cp ../supervisor/supervisor-ckan-worker.conf $SUPERVISOR_DIR
cp ../supervisor/ckan-uwsgi.conf $SUPERVISOR_DIR

# Replace values in supervisor-ckan-worker.conf
echo "Replacing strings in supervisor-ckan-worker.conf...."
sudo sed -i "s|CKAN_SITE_ID|${CKAN_SITE_ID}|g" "${SUPERVISOR_DIR}/supervisor-ckan-worker.conf"
sudo sed -i "s|LIB_DIR|${LIB_DIR}|g" "${SUPERVISOR_DIR}/supervisor-ckan-worker.conf"
sudo sed -i "s|CKAN_INI|${CKAN_INI}|g" "${SUPERVISOR_DIR}/supervisor-ckan-worker.conf"
sudo sed -i "s|SERVER_USER|${SERVER_USER}|g" "${SUPERVISOR_DIR}/supervisor-ckan-worker.conf"

# Replace values in ckan-uwsgi.conf
echo "Replacing strings in ckan-uwsgi.conf...."
sudo sed -i "s|CKAN_SITE_ID|${CKAN_SITE_ID}|g" "${SUPERVISOR_DIR}/ckan-uwsgi.conf"
sudo sed -i "s|LIB_DIR|${LIB_DIR}|g" "${SUPERVISOR_DIR}/ckan-uwsgi.conf"
sudo sed -i "s|ETC_DIR|${ETC_DIR}|g" "${SUPERVISOR_DIR}/ckan-uwsgi.conf"

# Edit supervisor.conf and add lines to app configs
echo "Checking supervisor.conf...."
FILE_PATH="/etc/supervisor/supervisord.conf"
if ! grep -q "$SUPERVISOR_DIR/supervisor-ckan-worker.conf" "$FILE_PATH" || ! grep -q "$SUPERVISOR_DIR/ckan-uwsgi.conf" "$FILE_PATH"; then
  sudo sh -c "echo ' $SUPERVISOR_DIR/supervisor-ckan-worker.conf\n $SUPERVISOR_DIR/ckan-uwsgi.conf' >> $FILE_PATH"
  echo "Supervisor conf edited..."
fi


# Check if the supervisor service is running
echo "Verifying supervisor is running..."
if ! sudo systemctl is-active --quiet supervisor; then
  echo "Supervisor is not running. Starting supervisor service..."
  sudo systemctl start supervisor
  echo "Waiting for 10 seconds to allow supervisor service to start..."
  sleep 10

  # Check again if supervisor service is running after delay
  if ! sudo systemctl is-active --quiet supervisor; then
	echo "Supervisor failed to start. Please check the logs for more details."
	exit 1
  else
	echo "Supervisor service started successfully."
  fi
else
  echo "Supervisor is already running."
fi

# Reread and update supervisor configuration
echo "Rereading and updating supervisor configuration..."
sudo supervisorctl reread
sudo supervisorctl update
