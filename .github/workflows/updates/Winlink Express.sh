#!/bin/bash

version="$(wget -qO- https://downloads.winlink.org/User%20Programs/ | sed 's/<br>/\n/g' | grep 'Winlink_Express_install' | sed 's/">.*//g ; s/.*="\///g' | sort -V | tail -1)"
all_url="https://downloads.winlink.org/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
