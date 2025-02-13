#!/bin/bash

. "../environment.sh"

# Ensure the script is executed with the necessary environment variables
if [ -z "$CKAN_SYSADMIN_NAME" ] || [ -z "$CKAN_SYSADMIN_PASSWORD" ] || [ -z "$CKAN_SYSADMIN_EMAIL" ] || [ -z "$CKAN_INI" ]; then
    echo "One or more required environment variables are missing."
    echo "Please set CKAN_SYSADMIN_NAME, CKAN_SYSADMIN_PASSWORD, CKAN_SYSADMIN_EMAIL, and CKAN_INI."
    exit 1
fi

# Activate the CKAN virtual environment
. $LIB_DIR/bin/activate

if ckan -c $CKAN_INI user list > /dev/null 2>&1 | grep -q $CKAN_SYSADMIN_NAME; then
    echo "User $CKAN_SYSADMIN_NAME already exists."
else
    # Create the user if it doesn't exist
	ckan -c "$CKAN_INI" user add "$CKAN_SYSADMIN_NAME" password="$CKAN_SYSADMIN_PASSWORD" email="$CKAN_SYSADMIN_EMAIL"
	echo "Created user $CKAN_SYSADMIN_NAME"
fi

# Grant sysadmin rights
ckan -c "$CKAN_INI" sysadmin add "$CKAN_SYSADMIN_NAME"
echo "Granted sysadmin rights to $CKAN_SYSADMIN_NAME"

deactivate