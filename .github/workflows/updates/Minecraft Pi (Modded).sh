#!/bin/bash

# To avoid writing a custom updater script for this application, we will combine the separate version IDs used in the one URL as one large version variable.

# Version
webVer="$(curl -s --connect-timeout 15 -X 'GET' 'https://gitea.thebrokenrail.com/api/v1/repos/minecraft-pi-reborn/minecraft-pi-reborn/releases/latest' -H 'accept: application/json' | jq --compact-output --raw-output '.tag_name')"

# This URL is only used for validation.
armhf_url="https://gitea.thebrokenrail.com/minecraft-pi-reborn/minecraft-pi-reborn/releases/download/${webVer}/minecraft-pi-reborn-client-${webVer}-armhf.AppImage"
arm64_url="https://gitea.thebrokenrail.com/minecraft-pi-reborn/minecraft-pi-reborn/releases/download/${webVer}/minecraft-pi-reborn-client-${webVer}-arm64.AppImage"
source "${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh"
