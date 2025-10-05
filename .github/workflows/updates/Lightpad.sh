#!/bin/bash

version=$(get_release libredeb/lightpad)
arm64_url="https://github.com/libredeb/lightpad/releases/download/v${version}/lightpad_${version}-1_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
