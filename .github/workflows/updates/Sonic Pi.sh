#!/bin/bash

webVer=$(curl -s https://sonic-pi.net | grep -m 1 armhf | sed 's/.*sonic-pi_//g; s/_bullseye\.armhf.*//g')
armhf_url="https://sonic-pi.net/files/releases/v${webVer%_*}/sonic-pi_${webVer}_bullseye.armhf.deb"
arm64_url="https://sonic-pi.net/files/releases/v${webVer%_*}/sonic-pi_${webVer}_bullseye.arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
