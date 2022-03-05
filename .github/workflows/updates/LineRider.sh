#!/bin/bash

webVer=$(get_release Sussy-OS/LRA-Community-Edition)
all_url="https://github.com/Sussy-OS/LRA-Community-Edition/releases/download/${webVer}/LineRider.game.auto-release.${webVer}-LR.zip"
pi_apps_ver="$(cat 'install' | grep 'version=' | sed 's/version=//')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
