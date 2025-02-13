#!/bin/bash

. "../environment.sh"


. $LIB_DIR/bin/activate

# Activity
# Upgrades the main database tables based on the activity extension needs
ckan -c $CKAN_INI db upgrade -p activity

# Setup the table creation and modifications needed for ytp comments to work
ckan -c $CKAN_INI comments initdb
ckan -c $CKAN_INI comments updatedb
ckan -c $CKAN_INI comments init_notifications_db

deactivate