#!/bin/bash 

webVer="$(wget -qO- "https://zoom.us/download?os=linux" | grep "var packageVersionX86" | sed 's/.*Version //g; s/;//g'  | sed "s/[()']//g" | sed 's/. //')"
armhf_url="https://zoom.us/client/${webVer}/zoom_i686.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh