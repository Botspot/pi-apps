#!/bin/bash

# To avoid writing a custom updater script for this application, we will combine the separate version IDs used in the one URL as one large version variable.

# Build ID
# This obtains the latest successful build ID.
build_id="$(curl -s https://jenkins.thebrokenrail.com/job/minecraft-pi-reborn/job/master/lastStableBuild/buildNumber)"

# Version Number
# This obtains the latest successful build's version number.
deb_id="$(curl -s "https://jenkins.thebrokenrail.com/job/minecraft-pi-reborn/job/master/${build_id}/api/json?tree=artifacts%5BrelativePath%5D" | jq | grep 'client-.*-arm64.AppImage"' | sed 's/.*client-//g' | sed 's/-arm64.*//g')"

# Update
webVer="${build_id}/artifact/out/minecraft-pi-reborn-client-${deb_id}"
# This URL is only used for validation.
armhf_url="https://jenkins.thebrokenrail.com/job/minecraft-pi-reborn/job/master/${webVer}-armhf.AppImage"
arm64_url="https://jenkins.thebrokenrail.com/job/minecraft-pi-reborn/job/master/${webVer}-arm64.AppImage"
source "${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh"
