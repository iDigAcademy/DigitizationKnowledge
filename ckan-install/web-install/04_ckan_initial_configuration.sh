#!/bin/bash

. "../environment.sh"

. $LIB_DIR/bin/activate

# Generate CKAN config file
echo "Generating CKAN config file: $CKAN_INI"
ckan generate config ${CKAN_INI}

# Update CKAN config
echo "Updating CKAN config file: $CKAN_INI"
ckan config-tool ${CKAN_INI} "SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe())')"

ckan config-tool $CKAN_INI "beaker.session.secret=$(python3 -c 'import secrets; print(secrets.token_urlsafe())')"
    ckan config-tool $CKAN_INI "WTF_CSRF_SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe())')"
    JWT_SECRET=$(python3 -c 'import secrets; print("string:" + secrets.token_urlsafe())')
    ckan config-tool $CKAN_INI "api_token.jwt.encode.secret=${JWT_SECRET}"
    ckan config-tool $CKAN_INI "api_token.jwt.decode.secret=${JWT_SECRET}"

ckan config-tool ${CKAN_INI} "ckan.plugins = envvars datastore"

ckan config-tool ${CKAN_INI} "ckan.site_id = ${CKAN_SITE_ID}"
ckan config-tool ${CKAN_INI} "ckan.site_url = ${CKAN_SITE_URL}"
ckan config-tool ${CKAN_INI} "sqlalchemy.url = ${CKAN_SQLALCHEMY_URL}"
ckan config-tool ${CKAN_INI} "ckan.datastore.write_url = ${CKAN_DATASTORE_WRITE_URL}"
ckan config-tool ${CKAN_INI} "ckan.datastore.read_url = ${CKAN_DATASTORE_READ_URL}"
ckan config-tool ${CKAN_INI} "solr_url = ${CKAN_SOLR_URL}"
ckan config-tool ${CKAN_INI} "solr_user = ${CKAN_SOLR_USER}"
ckan config-tool ${CKAN_INI} "solr_password = ${CKAN_SOLR_PASSWORD}"
ckan config-tool ${CKAN_INI} "ckan.redis.url = ${CKAN_REDIS_URL}"
ckan config-tool ${CKAN_INI} "ckan.storage_path = ${CKAN_STORAGE_PATH}"
ckan config-tool ${CKAN_INI} "smtp.server = ${CKAN_SMTP_SERVER}"
ckan config-tool ${CKAN_INI} "smtp.starttls = ${CKAN_SMTP_STARTTLS}"
ckan config-tool ${CKAN_INI} "smtp.user = ${CKAN_SMTP_USER}"
ckan config-tool ${CKAN_INI} "smtp.password = ${CKAN_SMTP_PASSWORD}"
ckan config-tool ${CKAN_INI} "smtp.mail_from = ${CKAN_SMTP_MAIL_FROM}"
ckan config-tool ${CKAN_INI} "ckan.max_resource_size = ${CKAN_MAX_UPLOAD_SIZE_MB}"

cp "${SRC_DIR}/ckan/wsgi.py" $ETC_DIR
cp "../config/ckan-uwsgi.ini" $ETC_DIR

sudo sed -i "s|CKAN_IP_PORT|${CKAN_IP_PORT}|g" "${ETC_DIR}/ckan-uwsgi.ini"
sudo sed -i "s|SERVER_USER|${SERVER_USER}|g" "${ETC_DIR}/ckan-uwsgi.ini"
sudo sed -i "s|ETC_DIR|${ETC_DIR}|g" "${ETC_DIR}/ckan-uwsgi.ini"
sudo sed -i "s|LIB_DIR|${LIB_DIR}|g" "${ETC_DIR}/ckan-uwsgi.ini"

deactivate