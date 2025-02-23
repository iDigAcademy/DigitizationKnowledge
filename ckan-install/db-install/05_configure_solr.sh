#!/bin/bash

. "../environment.sh"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Check if core already exists and configure if not.
STATUS_CODE=$(curl -sIN "http://localhost:8983/solr/$SOLR_CORE_NAME/admin/ping" | head -n 1 | awk '{print $2}')
if [ "$STATUS_CODE" == "200" ]; then
  echo "Core $CORE_NAME exists."
else
  echo "Core $CORE_NAME does not exist."

  # Create the CKAN core in Solr
  echo "Creating Solr core for CKAN..."
  sudo -u solr /opt/solr/bin/solr create -c "$SOLR_CORE_NAME"

  echo "Setting _default configset..."
  sudo curl http://localhost:8983/solr/$SOLR_CORE_NAME/config -d '{"set-user-property": {"update.autoCreateFields":"false"}}'

  # Copy Solr schema
  echo "Configuring Solr schema for CKAN..."
  sudo cp ${SCRIPT_DIR}/config/schema.xml /var/solr/data/${SOLR_CORE_NAME}/conf/managed-schema

  # Restart Solr to apply the configuration
  echo "Restarting Solr service..."
  sudo service solr restart

  # Clean up temporary files
  echo "Cleaning up..."
  sudo rm -f "solr-${SOLR_VERSION}.tgz"
  sudo rm -f ./install_solr_service.sh

  echo "Solr installation and CKAN core setup completed successfully!"

fi