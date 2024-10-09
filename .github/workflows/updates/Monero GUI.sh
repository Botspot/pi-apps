#!/bin/bash

version=$(get_release_raw monero-project/monero-gui)
arm64_url="https://github.com/monero-project/monero-gui/tree/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
