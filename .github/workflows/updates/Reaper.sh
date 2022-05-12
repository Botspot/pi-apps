#!/bin/bash
echo "Checking Reaper version and getting urls..."
webVer[0]=$(curl -s https://www.reaper.fm/download.php | grep "linux_aarch64.tar.xz" | sed -e 's/ /\n/g' -e 's/href="//g' -e 's/"//g' | grep 'linux_aarch64' | sed -e 's|files/.*/reaper||g' -e 's/_linux_aarch64.tar.xz//g')
base_ver="$(echo ${webVer[0]} | sed -e 's/.$//' -e 's/.$//')"
arm64_url[0]="https://www.reaper.fm/files/${base_ver}.x/reaper${webVer[0]}_linux_aarch64.tar.xz"
armhf_url[0]="https://www.reaper.fm/files/${base_ver}.x/reaper${webVer[0]}_linux_armv7l.tar.xz"
unset base_ver

echo -e "armhf: $armhf_url\narm64: $arm64_url\n webVer: $webVer"

echo "Checking ReaPack version..."
webVer[1]="$(get_release cfillion/reapack)"
arm64_url[1]="https://github.com/cfillion/reapack/releases/download/v${webVer[1]}/reaper_reapack-aarch64.so"
armhf_url[1]="https://github.com/cfillion/reapack/releases/download/v${webVer[1]}/reaper_reapack-armv7l.so"

source ${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh
