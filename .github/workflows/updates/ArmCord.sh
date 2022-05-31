#!/bin/bash

webVer=$(get_release ArmCord/ArmCord)
armhf_url="https://github.com/ArmCord/ArmCord/releases/download/v${webVer}/ArmCord_${webVer}_armv7l.deb"
arm64_url="https://github.com/ArmCord/ArmCord/releases/download/v${webVer}/ArmCord_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh