#!/bin/bash

dir=$( pwd )
if [ -d "$dir/install_me" ]; then
    cd "$dir/install_me" || exit 255
fi
# check if we have dnf or apt
if command -v dnf >/dev/null 2>&1; then
    install_command="dnf install -y"
    install_file="./packages_rhel.txt"
    query_command="rpm -qa | grep "
elif command -v apt-get --version >/dev/null 2>&1; then
    install_command="apt-get install -y"
    install_file="./packages_ubuntu.txt"
    query_command="dpkg -l | grep -v '^rc' | sed -E 's/  */ /g' | cut -d ' ' -f 2 | grep "
else
    echo "Unsupported package manager"
    exit 1
fi

while IFS= read -r package; do
  if eval "$query_command $package" > /dev/null 2>&1; then
    echo "Package $package is already installed."
  else
    echo "Package $package is NOT installed. Installing..."
    eval "sudo $install_command $package"
  fi
done < "$install_file"
