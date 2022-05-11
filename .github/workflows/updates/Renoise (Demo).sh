#!/bin/bash

webVer="$(curl -s https://files.renoise.com/demo/ | grep "armhf" | sed -e 's/<a href="//' -e 's/".*//' -e 's/Renoise_//' -e 's/_Demo_Linux_armhf.tar.gz//')"
armhf_url="https://renoise.com/demo/Renoise_${webVer}_Demo_Linux_armhf.tar.gz"
arm64_url="https://renoise.com/demo/Renoise_${webVer}_Demo_Linux_arm64.tar.gz"

source ${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh
