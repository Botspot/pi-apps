#!/bin/bash

webVer=$(get_release cfillion/reapack)

armhf_url="https://github.com/cfillion/reapack/releases/download/v${webVer}/reaper_reapack-armv7l.so"
arm64_url="https://github.com/cfillion/reapack/releases/download/v${webVer}/reaper_reapack-aarch64.so"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
