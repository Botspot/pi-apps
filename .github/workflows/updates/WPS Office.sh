#!/bin/bash

webVer="$(wget -qO- --timeout=5 https://linux.wps.cn/ | grep -o 'wps\-office_.*_arm64\.deb' | sed 's/^wps\-office_//g' | sed 's/_arm64\.deb//g')"
arm64_url="https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/$(echo "$webVer" | sed 's/.*\.//g')/wps-office_${webVer}_arm64.deb"
armhf_url="https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/$(echo "$webVer" | sed 's/.*\.//g')/wps-office_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
