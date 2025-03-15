#!/bin/bash

# Check if the script is running on an Ubuntu-like system
if ! grep -q "Ubuntu" /etc/os-release; then
  echo "This script only runs on Ubuntu or Ubuntu-like distributions."
  exit 0
fi

# Check if the file with package names is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file_with_package_names>"
  exit 1
fi

# Read the file and install each package if not already installed
if ! [ -f /var/lib/apt/periodic/update-success-stamp ]; then
        echo "please run 'sudo apt-get update'"
        exit 1
fi

while IFS= read -r package; do
  if dpkg -l | grep -q "^ii  $package"; then
    echo "Package $package is already installed."
  else
    echo "Package $package is NOT installed. Installing..."
    sudo apt-get install -y "$package"
  fi
done < "$1"
