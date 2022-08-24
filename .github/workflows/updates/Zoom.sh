#!/bin/bash 

webVer=$(wget --spider 'https://zoom.us/client/latest/zoom_x86_64.tar.xz' 2>&1 | grep '^Location: ' | awk '{print $2}' | awk -F/ '{print $5}')
arm64_url="https://zoom.us/client/${webVer}/zoom_x86_64.tar.xz"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
