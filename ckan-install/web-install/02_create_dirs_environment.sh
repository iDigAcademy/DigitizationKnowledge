#!/bin/bash

. "../environment.sh"

echo "Creating directories..."
# Create directories for ckan
mkdir -p "${ETC_DIR}"
mkdir -p "${LIB_DIR}"
mkdir -p "${STORAGE_DIR}"
mkdir -p "${SUPERVISOR_DIR}"

# Switch to the invoking user to create the virtual environment
python3 -m venv $LIB_DIR

# Create directory for log files of background worker supervisor
sudo mkdir -p /var/log/supervisor/ckan
