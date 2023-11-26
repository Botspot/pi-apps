#!/bin/bash

webVer=$(curl -s https://sonic-pi.net | grep -m 1 arm64.deb | sed 's/.*sonic-pi_//g; s/_bookworm\.arm64.*//g')
arm64_url="https://sonic-pi.net/files/releases/v${webVer%_*}/sonic-pi_${webVer}_bookworm.arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
