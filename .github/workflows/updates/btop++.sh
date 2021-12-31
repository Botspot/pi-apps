#!/bin/bash

webVer=$(get_release aristocratos/btop)
armhf_url="https://github.com/aristocratos/btop/releases/download/v${webVer}/btop-armv7l-linux-musleabihf.tbz"
arm64_url="https://github.com/aristocratos/btop/releases/download/v${webVer}/btop-aarch64-linux-musl.tbz"
pi_apps_ver_32="$(cat 'install-32' | grep 'version=' | sed 's/version=//')"
pi_apps_ver_64="$(cat 'install-64' | grep 'version=' | sed 's/version=//')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh