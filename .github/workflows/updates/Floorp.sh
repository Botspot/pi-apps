#!/bin/bash

version=$(get_release Floorp-Projects/Floorp)
arm64_url="https://github.com/Floorp-Projects/Floorp/releases/download/v${version}/floorp-linux-aarch64.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
