#!/bin/bash

webVer=$(get_release Floorp-Projects/Floorp)
arm64_url="https://github.com/Floorp-Projects/Floorp/releases/download/v${webVer}/floorp-${webVer}.linux-aarch64.tar.bz2"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
