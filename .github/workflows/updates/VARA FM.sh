#!/bin/bash

version="$(wget -qO- --header="User-Agent: This download is a result of the Pi-Apps store. Please stop blocking us. Please contact us if you have any questions. https://github.com/Botspot/pi-apps/issues/new/choose" https://downloads.winlink.org/VARA%20Products/ | sed 's/<br>/\n/g' | grep 'VARA%20FM' | sed 's/">.*//g ; s/.*="\///g' | sort -V | tail -1)"
all_url="https://downloads.winlink.org/$version"

# custom validate url function
# this will not overwrite the validate_url function created by the main update_apps.yml file for other update scripts
function validate_url(){
    if command wget -t 5 --waitretry=10 --timeout=10 --retry-connrefused -q --spider --header="User-Agent: This download is a result of the Pi-Apps store. Please stop blocking us. Please contact us if you have any questions. https://github.com/Botspot/pi-apps/issues/new/choose" "$1"; then
        return 0
    else
        return 1
    fi
}

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
