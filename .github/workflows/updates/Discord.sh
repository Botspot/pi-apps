#!/bin/bash

webVer=$(get_release SpacingBat3/WebCord)
armhf_url="https://github.com/SpacingBat3/WebCord/releases/download/v${webVer}/webcord_${webVer}_armhf.deb"
arm64_url="https://github.com/SpacingBat3/WebCord/releases/download/v${webVer}/webcord_${webVer}_arm64.deb"
pi_apps_ver_32="$(cat 'install-32' | grep 'version=' | sed 's/version=//')"
pi_apps_ver_64="$(cat 'install-64' | grep 'version=' | sed 's/version=//')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh