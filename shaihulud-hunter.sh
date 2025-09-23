#!/usr/bin/env bash
#
# Name:
#   shaihulud-hunter.sh
#
# About:
#   Uses jq to parse the JSON file and then recursively `grep` each package
#   name in the parent directory.
#
#   The affected-packages.json file was created from the list of
#   known, affected packages published by reversinglabs.com
#   at https://www.reversinglabs.com/blog/shai-hulud-worm-npm
#
# Prerequites:
#   bash, jq
#
# Usage:
#   Copy this folder into a directory that should be
#   scanned then run `./shaihulud-hunter.sh`
#
# Author:
#   Patrick Barabe <pbarabe@arizona.edu>
#
# Created:
#   23 Sep 2025
#
# Modification log:
#   23 Sep 2025

jq '.[].package_name' affected-packages.json | \
  xargs -I % sh -c "grep -rni % ${PWD}/.." | \
  grep -v "${PWD}"

