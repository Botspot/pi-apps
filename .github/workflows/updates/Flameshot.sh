#!/bin/bash

webVer=$(get_release flameshot-org/flameshot)
armhf_url="https://github.com/flameshot-org/flameshot/releases/download/v${webVer}/flameshot-${webVer}-1.debian-10.armhf.deb"
arm64_url="https://github.com/flameshot-org/flameshot/releases/download/v${webVer}/flameshot-${webVer}-1.debian-10.arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh