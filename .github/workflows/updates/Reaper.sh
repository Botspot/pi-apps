#!/bin/bash
echo "Checking Reaper version and getting urls..."
webVer[0]=$(curl -s https://www.reaper.fm/download.php | grep "linux_aarch64.tar.xz" | sed -e 's/ /\n/g' -e 's/href="//g' -e 's/"//g' | grep 'linux_aarch64' | sed -e 's|files/.*/reaper||g' -e 's/_linux_aarch64.tar.xz//g')
arm64_url[0]="https://reaper.fm/$(curl -s https://www.reaper.fm/download.php | grep 'linux_aarch64.tar.xz' | sed -e 's/ /\n/g' -e 's/href="//g' -e 's/"//g' | grep 'linux_aarch64')"
armhf_url[0]="https://reaper.fm/$(curl -s https://www.reaper.fm/download.php | grep 'linux_aarch64.tar.xz' | sed -e 's/ /\n/g' -e 's/href="//g' -e 's/"//g' | grep 'linux_armv7l')"

echo -e "armhf: $armhf_url\narm64: $arm64_url\n webVer: $webVer"

echo "Checking ReaPack version..."
webVer[1]="$(get_release cfillion/reapack)"
armhf_url[1]="https://github.com/cfillion/reapack/releases/download/v${webVer[1]}/reaper_reapack-armv7l.so"
arm64_url[1]="https://github.com/cfillion/reapack/releases/download/v${webVer[1]}/reaper_reapack-aarch64.so"

source ${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh
