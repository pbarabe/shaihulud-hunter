#!/usr/bin/env bash
####################################################################################################
#
# Name:
#   shaihulud-hunter.sh
#
# About:
#   Uses jq to parse the JSON file and then recursively `grep` each package
#   name in the parent directory.
#
#   The affected-packages.json file was created from the list of known, affected
#   packages published by reversinglabs.com:
#   https://www.reversinglabs.com/blog/shai-hulud-worm-npm
#
#   It was later augmented with additional packages identified in the Mini Shai Hulut compromise:
#   https://socket.dev/supply-chain-attacks/mini-shai-hulud
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
#   23 Sep 2025
#     - Initial creation
#
#   24 Sep 2025
#     - Refine logic to evaluate only package-lock.json files
#
#   12 May 2026
#     - Modified to also check for Mini Shai Hulud compromised packages
#     - Updated to accept alternate path to affected-packages.json file
#
####################################################################################################

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
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

# Check if we're running in test mode
search_directory="$1"
if [ "$1" == "-t" ]; then
  search_directory=$(dirname -- $(readlink -fn -- "$0"; echo x))
  echo "NOTICE: Running in test mode..."
  echo "Scanning '$search_directory/test/'."
fi

# Get location of this script
script_directory=$(dirname -- $(readlink -fn -- "$0"; echo x))

# Get affected packages file
packages_file="${script_directory}/affected-packages.json"

if [ "$#" -gt 1 ] && [ ! -z "$2" ]; then
    if [ -f "$2" ]; then
        packages_file="$2"
    else
        echo "NOTICE: Requested affected packages file '$2' does not exist."
    fi
fi

echo "Using affected packages file: '$packages_file'"

# Extract package names from the JSON file
package_names=$(jq -r '.[].package' "$packages_file")

# Create a temporary file to store the results
temp_file=$(mktemp)

# Find all package-lock.json files and search for package names
find "$search_directory" -name "package-lock.json" -o -name "yarn.lock" -o -name "pnpm-lock.yaml" | while read -r lock_file; do
    echo "Scanning $lock_file"
    for package in $package_names; do
        if grep -q "$package" "$lock_file"; then
            echo -e "\e[31mPossible match for package\e[0m '$package' in $lock_file" >> "$temp_file"
        fi
    done
done

# Display results
if [ -s "$temp_file" ]; then
    echo ""
    echo "Scan results:"
    sort "$temp_file" | uniq
    echo ""
    echo -e "\e[31mIMPORTANT:\e[0m Double-check matched files for affected packages and versions."
    echo "           False positives are possible, so review carefully."
    echo ""
else
    echo ""
    echo -e "\e[32mOK: \e[0mNo packages found in any package-lock.json, yarn.lock, or pnpm-lock.yaml files."
    echo ""
fi

# Clean up
rm "$temp_file"

