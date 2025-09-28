#!/bin/bash

version="$(curl -s https://files.renoise.com/demo/ | grep "arm64" | sed -e 's/<a href="//' -e 's/".*//' -e 's/Renoise_//' -e 's/_Demo_Linux_arm64.tar.gz//' | tail -1)"
arm64_url="https://files.renoise.com/demo/Renoise_${version}_Demo_Linux_arm64.tar.gz"

source ${GITHUB_WORKSPACE}/.github/workflows/update_github_script.sh
