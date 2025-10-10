#!/bin/bash

# Check if root_search_dir is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <root_search_dir>"
    exit 1
fi

# Get the directory of the script
script_dir=$(dirname "$(realpath "$0")")

# Get the root_search_dir from the command line argument and make it absolute
root_search_dir=$(realpath "$script_dir/$1")

# Find all files named 'editorconfig' starting from root_search_dir
find "$root_search_dir" -type f -name 'editorconfig' | while read -r file; do
    # Get the relative directory to root_search_dir
    relative_dir=$(dirname "${file#$root_search_dir/}")

    # Check if the relative directory exists relative to the current directory
    if [ -d "$relative_dir" ]; then
        if [ -e "$relative_dir/.editorconfig" ]; then
            echo "Warning: $relative_dir/.editorconfig already exists."
            rm -f "$relative_dir/.editorconfig"
        fi
        # Create a symbolic link with the name '.editorconfig' in the relative directory
        ln -sf "$(realpath "$file")" "$relative_dir/.editorconfig"
        echo "Created link: $relative_dir/.editorconfig -> $(realpath "$file")"
    fi
done
