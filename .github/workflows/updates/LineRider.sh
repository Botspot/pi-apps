#!/bin/bash

webVer=$(get_release Sussy-OS/LineRiderUpdater)
all_url="https://github.com/Sussy-OS/LineRiderUpdater/releases/download/${webVer}/TempFile-${webVer}.txt"
pi_apps_ver="$(cat 'install' | grep 'version=' | sed 's/version=//')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
