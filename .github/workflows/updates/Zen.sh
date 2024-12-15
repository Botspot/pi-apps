#!/bin/bash

version=$(get_release zen-browser/desktop)
arm64_url="https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-aarch64.tar.bz2"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
