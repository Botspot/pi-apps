#!/bin/bash

webVer=$(curl -s https://sonic-pi.net | grep -m 1 armhf | sed 's/.*sonic-pi_//g; s/_armhf.*//g')
armhf_url="https://sonic-pi.net/files/releases/v${webVer%_*}/sonic-pi_${webVer}_armhf.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh