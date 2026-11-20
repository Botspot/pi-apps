#!/bin/bash

version=$(get_release localsend/localsend)
arm64_url="https://github.com/localsend/localsend/releases/download/v${version}/LocalSend-${version}-linux-arm-64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
