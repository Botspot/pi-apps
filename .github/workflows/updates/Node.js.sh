#!/bin/bash

version[1]=$(get_release_raw nvm-sh/nvm)
armhf_url[1]="https://raw.githubusercontent.com/nvm-sh/nvm/${version[1]}/install.sh"

# obtain latest lts version of nodejs from nvm to avoid any deployment lag
# previously the version was obtained from the website which could update faster than nvm itself, leaving to pi-apps prompting users to update too early
# https://github.com/nvm-sh/nvm/issues/3451
wget -qO nvm.sh "https://raw.githubusercontent.com/nvm-sh/nvm/${version[1]}/nvm.sh"
# v22 release is the last to support ARMhf and is codename "jod"
version[0]=$(source ./nvm.sh; nvm version-remote --lts=jod)
rm -f nvm.sh

armhf_url[0]="https://nodejs.org/dist/${version[0]}/node-${version[0]}-linux-armv7l.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh


version[1]=$(get_release_raw nvm-sh/nvm)
arm64_url[1]="https://raw.githubusercontent.com/nvm-sh/nvm/${version[1]}/install.sh"

wget -qO nvm.sh "https://raw.githubusercontent.com/nvm-sh/nvm/${version[1]}/nvm.sh"
# the latest LTS supports ARM64
version[0]=$(source ./nvm.sh; nvm version-remote --lts)
rm -f nvm.sh

arm64_url[0]="https://nodejs.org/dist/${version[0]}/node-${version[0]}-linux-arm64.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
