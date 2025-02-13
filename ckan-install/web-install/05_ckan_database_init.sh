#!/bin/bash

. "../environment.sh"

. $LIB_DIR/bin/activate

ckan -c $CKAN_INI db init

deactivate