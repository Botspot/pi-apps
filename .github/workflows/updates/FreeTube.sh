#!/bin/bash

webVer=$(get_prerelease FreeTubeApp/FreeTube)
armhf_url="https://github.com/FreeTubeApp/FreeTube/releases/download/v${webVer}/freetube_${webVer%-beta}_beta_armv7l.deb"
arm64_url="https://github.com/FreeTubeApp/FreeTube/releases/download/v${webVer}/freetube_${webVer%-beta}_beta_arm64.deb"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
