#!/bin/bash

echo "Checking Renoise version and getting download urls..."

for (( i=999; i > 0; i-- )); do
	webVer="$(echo "$i" | sed -e 's/^\(.\{1\}\)/\1_/' -e 's/^\(.\{3\}\)/\1_/')"
        armhf_url="https://files.renoise.com/demo/Renoise_${webVer}_Demo_Linux_armhf.tar.gz"
        arm64_url="https://files.renoise.com/demo/Renoise_${webVer}_Demo_Linux_arm64.tar.gz"
        wget --spider $armhf_url &>/dev/null && break
	echo $armhf_url
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
