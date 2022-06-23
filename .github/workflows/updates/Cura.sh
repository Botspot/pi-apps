#!/bin/bash

webVer[0]=$(get_release smartavionics/Cura)
webVer[1]=$(get_release unlimitedbacon/stl-thumb)
armhf_url[0]="https://github.com/smartavionics/Cura/releases/download/${webVer[0]}/Cura-${webVer[0]}-mb-armhf.AppImage"
armhf_url[1]="https://github.com/unlimitedbacon/stl-thumb/releases/download/v${webVer[1]}/stl-thumb_${webVer[1]}_armhf.deb"
arm64_url[0]="https://github.com/smartavionics/Cura/releases/download/${webVer[0]}/Cura-${webVer[0]}-mb-aarch64.AppImage"
arm64_url[1]="https://github.com/unlimitedbacon/stl-thumb/releases/download/v${webVer[1]}/stl-thumb_${webVer[1]}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
