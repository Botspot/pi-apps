#!/bin/bash

echo "Checking Renoise version and getting download urls..."

webVer=$(curl -s https://files.renoise.com/demo/ | grep "armhf" | sed -e 's/<a href="//' -e 's/".*//' -e 's/Renoise_//' -e 's/_Demo_Linux_armhf.tar.gz//')

armhf_url="https://renoise.com/demo/$(curl -s https://files.renoise.com/demo/ | grep "armhf" | sed -e 's/<a href="//' -e 's/".*//')"
arm64_url="https://renoise.com/demo/$(curl -s https://files.renoise.com/demo/ | grep "arm64" | sed -e 's/<a href="//' -e 's/".*//')"
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

echo "Latest version: ${webVer}"

source ${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh
