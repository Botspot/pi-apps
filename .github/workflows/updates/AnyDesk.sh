#!/bin/bash

webVer=$(wget -qO- https://download.anydesk.com/rpi/  | grep '.deb</a><br>$' | tail -n 1 | sed 's+.*<a href="./anydesk_++g; s+_armhf.deb">anydesk_.*_armhf.deb</a><br>++g')
armhf_url="https://download.anydesk.com/rpi/anydesk_${webVer}_armhf.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
