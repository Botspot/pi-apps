#!/bin/bash

webVer[0]=$(get_release dave-theunsub/clamtk)
webVer[1]=$(get_release dave-theunsub/thunar-sendto-clamtk)
all_url[0]="https://github.com/dave-theunsub/clamtk/releases/download/v${webVer[0]}/clamtk_${webVer[0]}-1_all.deb"
all_url[1]="https://github.com/dave-theunsub/thunar-sendto-clamtk/releases/download/v${webVer[1]}/thunar-sendto-clamtk_${webVer[1]}-1_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh