#!/bin/bash

webVer=$(get_release_raw actionschnitzel/PiGro-Aid-)
all_url="https://github.com/actionschnitzel/PiGro-Aid-/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh