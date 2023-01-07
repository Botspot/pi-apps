#!/bin/bash

webVer=$(get_release_raw Genymobile/scrcpy)
all_url="https://github.com/Genymobile/scrcpy/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh