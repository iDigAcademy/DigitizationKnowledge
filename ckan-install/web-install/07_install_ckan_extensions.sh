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
pip install -e "git+https://github.com/iDigAcademy/ckanext-digitizationknowledge.git@main#egg=ckanext-digitizationknowledge"

deactivate