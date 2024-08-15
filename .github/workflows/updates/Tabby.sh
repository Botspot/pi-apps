#!/bin/bash

version=$(get_release Eugeny/tabby)
armhf_url="https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-armv7l.deb"
arm64_url="https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
