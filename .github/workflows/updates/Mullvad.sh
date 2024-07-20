#!/bin/bash


webVer="$(wget -qO- https://sourceforge.net/projects/tor-browser-ports/rss?path=/ | grep mullvad-browser-linux -m1 | sed 's/.*\[\/mullvad-//g ; s/\/mullvad-browser-linux.*//g')"
armhf_url="https://sourceforge.net/projects/tor-browser-ports/files/mullvad-${webVer}/mullvad-browser-linux-armhf-${webVer}.tar.xz/download"
arm64_url="https://sourceforge.net/projects/tor-browser-ports/files/mullvad-${webVer}/mullvad-browser-linux-arm64-${webVer}.tar.xz/download"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
