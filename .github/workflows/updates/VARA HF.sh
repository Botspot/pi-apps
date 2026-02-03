#!/bin/bash

version="$(wget -qO- https://downloads.winlink.org/VARA%20Products/ | sed 's/<br>/\n/g' | grep 4.9.0 | sed 's/">.*//g ; s/.*="\///g')"
all_url="https://downloads.winlink.org/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
