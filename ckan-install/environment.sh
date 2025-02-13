#!/bin/bash

set -e

if [[ -z "$1" ]]; then
    echo "Must pass environment variable (prod or dev)"
  	exit;
fi

source "../ckan_$1.env"
