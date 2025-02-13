#!/bin/bash

. "../environment.sh"

echo "Running Postgresql file..."

sudo cp "psql-template.sql" /tmp/psql-tmp.sql

sudo sed -i "s/CKAN_DB_USER/${CKAN_DB_USER}/g" /tmp/psql-tmp.sql
sudo sed -i "s/CKAN_DB/${CKAN_DB}/g" /tmp/psql-tmp.sql
sudo sed -i "s/DATASTORE_READONLY_USER/${DATASTORE_READONLY_USER}/g" /tmp/psql-tmp.sql
sudo sed -i "s/DATASTORE_DB/${DATASTORE_DB}/g" /tmp/psql-tmp.sql

sudo chown postgres.postgres /tmp/psql-tmp.sql;
sudo -i -u postgres psql -d $DATASTORE_DB -f /tmp/psql-tmp.sql 2>&1
sudo rm /tmp/psql-tmp.sql

echo "Completed running Postgresql file..."
