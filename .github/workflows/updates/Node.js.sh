#!/bin/bash

webVer[0]=$(wget -qO- https://nodejs.org/en/download/current/ | tr '<>' '\n' | grep 'https://nodejs\.org/dist/.*\.tar\.gz' -m1 | tr '/' '\n' | grep '^v')
armhf_url[0]="https://nodejs.org/dist/${webVer}/node-${webVer}-linux-armv7l.tar.xz"
arm64_url[0]="https://nodejs.org/dist/${webVer}/node-${webVer}-linux-arm64.tar.xz"

webVer[1]=$(get_release_raw nvm-sh/nvm)
all_url[1]="https://raw.githubusercontent.com/nvm-sh/nvm/${webVer[1]}/install.sh"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
