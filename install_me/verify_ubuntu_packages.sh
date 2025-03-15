#!/bin/bash

# Check if the script is running on an Ubuntu-like system
if ! grep -q "Ubuntu" /etc/os-release; then
  echo "This script verify Ubuntu and this is not ubunto."
  exit 0
fi

# Check if the file with package names is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file_with_package_names>"
  exit 1
fi

# Read the file and verify each package
while IFS= read -r package; do
  if dpkg -l | grep -q "^ii  $package"; then
    echo "Package $package is installed."
  else
    echo "Package $package is NOT installed."
    exit 1
  fi
done < "$1"

exit 0
