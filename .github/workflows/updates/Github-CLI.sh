#!/bin/bash

webVer=$(get_release cli/cli)
armhf_url="https://github.com/cli/cli/releases/download/v${webVer}/gh_${webVer}_linux_armv6.deb"
arm64_url="https://github.com/cli/cli/releases/download/v${webVer}/gh_${webVer}_linux_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh