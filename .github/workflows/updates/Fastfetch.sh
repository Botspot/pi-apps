#!/bin/bash

version=$(get_release fastfetch-cli/fastfetch)
armhf_url="https://github.com/fastfetch-cli/fastfetch/releases/download/${version}/fastfetch-linux-armv7l.deb"
arm64_url="https://github.com/fastfetch-cli/fastfetch/releases/download/${version}/fastfetch-linux-aarch64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
