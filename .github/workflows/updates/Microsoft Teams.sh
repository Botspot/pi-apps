#!/bin/bash

webVer=$(get_release IsmaelMartinez/teams-for-linux)
armhf_url="https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v${webVer}/teams-for-linux_${webVer}_armv7l.deb"
arm64_url="https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v${webVer}/teams-for-linux_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh