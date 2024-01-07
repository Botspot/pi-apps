#!/bin/bash

webVer=$(get_release_raw hrydgard/ppsspp)
all_url="https://github.com/hrydgard/ppsspp/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh