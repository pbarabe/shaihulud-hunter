#!/usr/bin/env bash
#
# Name:
#   shaihulud-hunter.sh
#
# About:
#   Uses jq to parse the JSON file and then recursively `grep` each package
#   name in the parent directory.
#
#   The affected-packages.json file was created from the list of known, affected
#   packages published by reversinglabs.com at
#   https://www.reversinglabs.com/blog/shai-hulud-worm-npm
#
# Prerequites:
#   bash, jq
#
# Usage:
#   shaihulud-hunter.sh <directory> {affected-packages.json}
#
# Author:
#   Patrick Barabe <pbarabe@arizona.edu>
#
# Modification log:
#   23 Sep 2025 - Initial creation
#   24 Sep 2025 - Refine logic to evaluate only package-lock.json files

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_name> {affected-packages.json}"
    echo "       Search <directory_name> using patterns from optional {affected-packages.json}"
    echo ""
    echo "Usage: $0 -t"
    echo "       Scan test files in ./test/ dir"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq."
    exit 1
fi

# Get location of this script
script_directory=$(dirname -- $(readlink -fn -- "$0"; echo x))

# Assign arguments to variables
search_directory="$1"
packages_file="${2:-$script_directory/affected-packages.json}"

if [ "$1" == "-t" ]; then
  search_directory=$(dirname -- $(readlink -fn -- "$0"; echo x))
fi

# Extract package names from the JSON file
package_names=$(jq -r '.[].package_name' "$packages_file")

# Create a temporary file to store the results
temp_file=$(mktemp)

# Find all package-lock.json files and search for package names
find "$search_directory" -name "package-lock.json" -o -name "yarn.lock" -o -name "pnpm-lock.yaml" | while read -r lock_file; do
    echo "Scanning $lock_file"
    for package in $package_names; do
        if grep -q "$package" "$lock_file"; then
            echo "Found package '$package' in $lock_file" >> "$temp_file"
        fi
    done
done

# Display results
if [ -s "$temp_file" ]; then
    echo ""
    echo "Scan results:"
    cat "$temp_file"
else
    echo "No packages found in any package-lock.json files."
fi

# Clean up
rm "$temp_file"

