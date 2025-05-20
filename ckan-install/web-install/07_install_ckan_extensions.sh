#!/bin/bash

. "../environment.sh"

. $LIB_DIR/bin/activate

### XLoader
pip install -e "git+https://github.com/ckan/ckanext-xloader.git@master#egg=ckanext-xloader"
pip install -r ${SRC_DIR}/ckanext-xloader/requirements.txt
pip install -U requests[security]

### Scheming
pip install -e "git+https://github.com/ckan/ckanext-scheming.git#egg=ckanext-scheming"

### Ytp-comments 
pip install -e "git+https://github.com/qld-gov-au/ckanext-ytp-comments.git#egg=ckanext-ytp-comments"
pip install 'lxml[html_clean]'
pip install profanityfilter

### Digitization Knowledge Base Custom Extension
#pip install -e $CKAN_DIGITIZATION_KNOWLEDGE_GIT

## Install ckanext-digitizationknowledge from source

## Uninstall and delete old directory if already present

### Check if extension is installed, uninstall it
if pip show ckanext-digitizationknowledge &> /dev/null; then
    echo "Found existing installation. Uninstalling ckanext-digitizationknowledge..."
    pip uninstall -y ckanext-digitizationknowledge
fi

### Remove directory if it exists
old_dir="$SRC_DIR/ckanext-digitizationknowledge"
if [ -d "$old_dir" ]; then
    echo "Removing old installation directory at $old_dir"
    rm -rf "$old_dir"
fi

git clone -b main https://github.com/iDigAcademy/ckanext-digitizationknowledge.git ${SRC_DIR}/ckanext-digitizationknowledge
pip install -e ${SRC_DIR}/ckanext-digitizationknowledge

### INstall ckanedt-digitizationknowledge-theme from source

git clone -b dev https://github.com/iDigAcademy/ckanext-digitizationknowledge-theme.git ${SRC_DIR}/ckanext-digitizationknowledge-theme.git
pip install -e ${SRC_DIR}/ckanext-digitizationknowledge-theme.git


deactivate