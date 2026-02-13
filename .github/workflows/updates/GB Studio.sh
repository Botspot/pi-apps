#!/bin/bash

version=$(get_release chrismaltby/gb-studio)
arm64_url="https://github.com/chrismaltby/gb-studio/releases/download/v${version}/gb-studio-linux-arm64-debian.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
