#!/bin/bash

version="$(wget -qO- --user-agent="Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36" https://downloads.winlink.org/User%20Programs/ | sed 's/<br>/\n/g' | grep 'Winlink_Express_install' | sed 's/">.*//g ; s/.*="\///g' | sort -V | tail -1)"
all_url="https://downloads.winlink.org/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
