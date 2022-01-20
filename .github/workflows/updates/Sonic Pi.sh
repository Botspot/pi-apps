#!/bin/bash

webVer=$(curl -s https://sonic-pi.net | grep -m 1 armhf | sed 's/.*sonic-pi_//g; s/_armhf.*//g')
armhf_url="https://sonic-pi.net/files/releases/v${version}/sonic-pi_${version}_armhf.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh