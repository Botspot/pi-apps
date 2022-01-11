#!/bin/bash

webVer=$(get_release alienzhangyw/BlockPi)
armhf_url="https://github.com/alienzhangyw/BlockPi/releases/download/v${webVer}/blockpi_${webVer}_armv7l.deb"
arm64_url="https://github.com/alienzhangyw/BlockPi/releases/download/v${webVer}/blockpi_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh