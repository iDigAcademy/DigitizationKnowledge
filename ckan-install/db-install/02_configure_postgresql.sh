#!/bin/bash

. "../environment.sh"

# Check for required environment variables
required_vars=(
    "CKAN_DB_USER"
    "CKAN_DB_PASSWORD"
    "CKAN_DB"
    "DATASTORE_READONLY_USER"
    "DATASTORE_READONLY_PASSWORD"
    "DATASTORE_DB"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Required environment variable $var is not set"
        echo "Required variables:"
        printf '%s\n' "${required_vars[@]}"
        exit 1
    fi
done

# Function to check if a PostgreSQL role exists and create it if not
check_and_create_role() {
	local role_name=$1
	local role_password=$2

	if sudo -u postgres psql -Atq -c "SELECT 1 FROM pg_roles WHERE rolname = '$role_name';" | grep -q 1; then
		echo "Role '$role_name' already exists."
	else
		sudo -u postgres psql -Atq -c "CREATE ROLE $role_name NOSUPERUSER CREATEDB CREATEROLE LOGIN PASSWORD '$role_password';"
		echo "Role '$role_name' created successfully."
	fi
}

# Check and create roles for CKAN_DB_USER and DATASTORE_READONLY_USER
check_and_create_role "$CKAN_DB_USER" "$CKAN_DB_PASSWORD"
check_and_create_role "$DATASTORE_READONLY_USER" "$DATASTORE_READONLY_PASSWORD"

# Function to check and create a PostgreSQL database if it doesn't exist
check_and_create_database() {
	local db_name=$1
	local owner=$2

	if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "$db_name"; then
		echo "Database '$db_name' already exists."
	else
		sudo -u postgres psql -v ON_ERROR_STOP=1 <<-EOSQL
			CREATE DATABASE "$db_name" OWNER "$owner" ENCODING 'utf-8';
EOSQL
		echo "Database '$db_name' created successfully."
	fi
}

# Check and create databases for CKAN_DB and DATASTORE_DB
check_and_create_database "$CKAN_DB" "$CKAN_DB_USER"
check_and_create_database "$DATASTORE_DB" "$CKAN_DB_USER"
