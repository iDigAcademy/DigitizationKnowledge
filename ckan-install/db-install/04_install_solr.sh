#!/bin/bash

. "../environment.sh"

sudo apt-get update

# Check if Java is installed.
if dpkg -l | grep -qw openjdk-11-jdk; then
	echo "Package openjdk-11-jdk is installed."
else
	echo "Installing openjdk-11-jdk"
	sudo apt install openjdk-11-jdk --no-install-recommends -y
fi

# Check if Solr is already installed
if systemctl list-unit-files --type=service | grep -qw solr.service; then
	echo "Solr is already installed and running."
else
	echo "Solr is not installed. Proceeding with the installation..."

	# Download Solr
    echo "Downloading Solr version ${SOLR_VERSION}..."
    curl -L "${SOLR_DOWNLOAD_URL}" -o "solr-${SOLR_VERSION}.tgz"

    # Extract and install Solr
    echo "Extracting and installing Solr..."
    sudo tar xzf "solr-${SOLR_VERSION}.tgz" "solr-${SOLR_VERSION}/bin/install_solr_service.sh" --strip-components=2
    sudo bash ./install_solr_service.sh "solr-${SOLR_VERSION}.tgz"
fi

exit
