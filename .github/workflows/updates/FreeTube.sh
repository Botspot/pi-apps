#!/bin/bash

webVer="$(wget -qO- https://apt.raspbian-addons.org/debian/pool/main/f/freetube/ | grep -m 1 "freetube.*armhf.deb" | grep -o '_.*_' | tr -d '_')"
armhf_url="https://apt.raspbian-addons.org/debian/pool/main/f/freetube/freetube_${webVer}_armhf.deb"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh

unset webVer
unset armhf_url

webVer=$(get_prerelease FreeTubeApp/FreeTube)
arm64_url="https://github.com/FreeTubeApp/FreeTube/releases/download/v${webVer}/freetube_${webVer%-beta}_arm64.deb"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
