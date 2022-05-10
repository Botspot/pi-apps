#!/bin/bash
echo "Checking Reaper major version..."
for (( i=0; i < 10; i++ )); do
        base_ver_test_url="https://reaper.fm/files/${i}.x/reaper${i}01_linux_armv7l.tar.xz"
	base_ver="${i}"
        wget --spider $base_ver_test_url &>/dev/null && break
done

echo "Checking Reaper minor version and getting download urls..."

for (( i=99; i > 0; i-- )); do
	armhf_url="https://reaper.fm/files/${base_ver}.x/reaper${base_ver}${i}_linux_armv7l.tar.xz"
	arm64_url="https://reaper.fm/files/${base_ver}.x/reaper${base_ver}${i}_linux_aarch64.tar.xz"
	minor_ver="${i}"
	wget --spider $armhf_url &>/dev/null && break
done

echo "Double-checking urls..."

if ! wget --spider ${arm64_url} &>/dev/null; then
	echo "\$arm64_url ($arm64_url) isn't good! Something bad happened, not updating arm64..."; unset arm64_url
else
	echo "\$arm64_url ($arm64_url) checks out! We're good to go."
fi

if ! wget --spider ${armhf_url} &>/dev/null; then
        echo "\$armhf_url ($armhf_url) isn't good! Something bad happened, not updating armhf..."; unset armhf_url
else
        echo "\$armhf_url ($armhf_url) checks out! We're good to go."
fi

webVer="${base_ver}${minor_ver}"
echo "Latest version: ${webVer}"

source ${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh
