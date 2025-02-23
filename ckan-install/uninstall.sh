#!/bin/bash

sudo rm -rf ../ckan

# Remove Postgresql
sudo systemctl stop postgresql
sudo apt-get --purge remove postgresql postgresql-client-common postgresql-common postgresql-contrib -y
sudo rm -rf /etc/postgresql
sudo rm -rf /etc/postgresql-common
sudo rm -rf /var/lib/postgresql
sudo rm -rf /var/log/postgresql
sudo userdel -r postgres
sudo groupdel postgres
sudo apt-get autoremove

# Remove Solr
sudo systemctl stop solr
sudo rm -r /opt/solr
sudo rm -rf /var/solr
sudo rm -rf /opt/solr-9.70
sudo rm /etc/init.d/solr
sudo deluser --remove-home solr
sudo deluser --group solr
sudo update-rc.d -f solr remove
sudo rm -rf /etc/default/solr.in.sh

