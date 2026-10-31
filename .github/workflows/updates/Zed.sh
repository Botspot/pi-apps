#!/bin/bash

version=$(get_release zed-industries/zed)
arm64_url="https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-aarch64.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
