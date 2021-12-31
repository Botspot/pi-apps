#!/bin/bash

webVer[0]=$(get_release subhra74/xdm)
all_url[0]="https://github.com/subhra74/xdm/releases/download/${webVer[0]}/xdm-setup-${webVer[0]}.tar.xz"
pi_apps_ver[0]="$(cat 'install' | grep 'version=' | sed 's/version=//')"

webVer[1]=$(get_release ytdl-org/youtube-dl)
all_url[1]="https://github.com/ytdl-org/youtube-dl/releases/download/${webVer[1]}/youtube-dl"
pi_apps_ver[1]="$(cat 'install' | grep 'version2=' | sed 's/version2=//')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh