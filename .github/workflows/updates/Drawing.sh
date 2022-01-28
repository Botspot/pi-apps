#!/bin/bash

webVer="$(wget -qO- https://launchpad.net/~cartes/+archive/ubuntu/drawing | grep 0ubuntu1~focal | xargs)"
armhf_url="https://launchpad.net/~cartes/+archive/ubuntu/drawing/+files/drawing_${webVer}_armhf.deb"
arm64_url="https://launchpad.net/~cartes/+archive/ubuntu/drawing/+files/drawing_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
