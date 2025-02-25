#!/bin/bash

. "../environment.sh"

. $LIB_DIR/bin/activate

# Add more to the list depending which plugins were installed in the previous step
ckan config-tool ${CKAN_INI} "ckan.plugins = envvars activity tabledesigner datatables_view datastore xloader ytp_comments digitizationknowledge scheming_datasets"

## Xloader
### Creates an API token for xloader to use
### If we want to be able to run this script safely to update configurations after installation then we should find a better place for the xloader part
### This will create a new API token with the name of xloader everytime and so if run more than once we will have in the system several tokens with the same name
ckan config-tool ${CKAN_INI} "ckanext.xloader.api_token = $(ckan -c $CKAN_INI user token add $CKAN_SYSADMIN_NAME xloader | tail -n 1 | tr -d '\t')"
ckan config-tool ${CKAN_INI} "ckanext.xloader.site_url=${CKAN_SITE_URL}"

## Scheming

### Add the custom schemas
ckan config-tool ${CKAN_INI} "scheming.dataset_schemas = ckanext.digitizationknowledge:schemas/book.yaml \
ckanext.digitizationknowledge:schemas/digital-document.yaml \
ckanext.digitizationknowledge:schemas/event.yaml \
ckanext.digitizationknowledge:schemas/learning-resource.yaml \
ckanext.digitizationknowledge:schemas/scholarly-article.yaml \
ckanext.digitizationknowledge:schemas/software-application.yaml \
ckanext.digitizationknowledge:schemas/software-source-code.yaml \
ckanext.digitizationknowledge:schemas/video-object.yaml \
ckanext.digitizationknowledge:schemas/web-content.yaml"

### Add path to custom presets
ckan config-tool ${CKAN_INI} "scheming.presets = ckanext.scheming:presets.json \
ckanext.digitizationknowledge:schemas/presets.yaml"

## Ytp comments

ckan config-tool ${CKAN_INI} "ckan.comments.follow_mute_enabled = True"

### Setting that shows the comments at the end of the dataset page instead of in a separate tab
ckan config-tool ${CKAN_INI} "ckan.comments.show_comments_tab_page = False"
