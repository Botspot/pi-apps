#!/bin/bash

# note, this webVer is potentially unstable and may not always work in the future depending on the package name (like what happened on 27 Mar 2022)
# find a better way to do this in the future

webVer="$(wget -qO- https://launchpad.net/~cartes/+archive/ubuntu/drawing | grep ~focal | xargs)"
armhf_url="https://launchpad.net/~cartes/+archive/ubuntu/drawing/+files/drawing_${webVer}_armhf.deb"
arm64_url="https://launchpad.net/~cartes/+archive/ubuntu/drawing/+files/drawing_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
