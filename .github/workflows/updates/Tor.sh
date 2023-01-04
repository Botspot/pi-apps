#!/bin/bash


webVer="$(wget -qO- https://sourceforge.net/projects/tor-browser-ports/files | grep -F 'Download Latest Version' --after 1 | tail -n -1 | tr '<>\-_' '\n' | sed -n 8p)"
armhf_url="https://sourceforge.net/projects/tor-browser-ports/files/${webVer}/tor-browser-linux-armhf-${webVer}_ALL.tar.xz/download"
arm64_url="https://sourceforge.net/projects/tor-browser-ports/files/${webVer}/tor-browser-linux-armhf-${webVer}_ALL.tar.xz/download"

if [ -d ~/tor-browser/ ];then
  mv ~/tor-browser ~/tor-browser_en-US
fi

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
