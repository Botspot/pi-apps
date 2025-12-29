#!/bin/bash

webVer[1]=$(get_release_raw nvm-sh/nvm)
all_url[1]="https://raw.githubusercontent.com/nvm-sh/nvm/${webVer[1]}/install.sh"

# obtain latest lts version of nodejs from nvm to avoid any deployment lag
# previously the version was obtained from the website which could update faster than nvm itself, leaving to pi-apps prompting users to update too early
# https://github.com/nvm-sh/nvm/issues/3451
wget -qO nvm.sh "https://raw.githubusercontent.com/nvm-sh/nvm/${webVer[1]}/nvm.sh"
webVer[0]=$(source ./nvm.sh; nvm version-remote --lts)
rm -f nvm.sh

armhf_ver=$(source ./nvm.sh; nvm version-remote --lts)
armhf_url[0]="https://nodejs.org/dist/${armhf_ver}/node-${armhf_ver}-linux-armv7l.tar.xz"
arm64_url[0]="https://nodejs.org/dist/${webVer}/node-${webVer}-linux-arm64.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
