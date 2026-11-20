#!/bin/bash

version=$(get_release AntoninPrazsky/BS3D)
arm64_url="https://github.com/AntoninPrazsky/BS3D/releases/download/v${version}/BS3D-v${version}-linux-arm64.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
