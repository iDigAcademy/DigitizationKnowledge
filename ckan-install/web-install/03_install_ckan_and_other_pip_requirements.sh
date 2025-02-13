#!/bin/bash

. "../environment.sh"

# Activate the virtual environment
. $LIB_DIR/bin/activate

# Install CKAN
pip install --upgrade pip

pip install uwsgi

# Install CKAN Development
pip install -e "git+https://github.com/ckan/ckan.git@${CKAN_REF}#egg=ckan"
pip install -r "${SRC_DIR}/ckan/requirements.txt"

# Install bs4 due to error caused in ckanext-ytp-comments
pip install beautifulsoup4

# Installs ckanext-envars so CKAN can get information from environment variables
pip install -e git+https://github.com/okfn/ckanext-envvars.git@v0.0.6#egg=ckanext-envvars

deactivate