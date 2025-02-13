#!/bin/bash

sudo apt-get update

# From docs
from_docs=("python3-dev" "libpq-dev" "python3-pip" "python3-venv" "git-core" "libmagic1")
# Loop through the array
for element in "${from_docs[@]}"; do
    if dpkg -l | grep -qw $element; then
        echo "Package ${element} is installed."
    else
        echo "Installing ${element}."
        sudo apt install $element --no-install-recommends -y
    fi
done

# From Base Dockerfile (ckeck if needed)
from_base=("apt-utils" "git" "g++" "linux-headers-generic" "libtool" "wget")
# Loop through the array
for element in "${from_base[@]}"; do
    if dpkg -l | grep -qw $element; then
        echo "Package ${element} is installed."
    else
        echo "Installing ${element}."
        sudo apt install $element --no-install-recommends -y
    fi
done

# Required for ypt-comments
ypt_comments=("libxml2-dev" "libxslt1-dev")
# Loop through the array
for element in "${ypt_comments[@]}"; do
    if dpkg -l | grep -qw $element; then
        echo "Package ${element} is installed."
    else
        echo "Installing ${element}."
        sudo apt install $element --no-install-recommends -y
    fi
done

