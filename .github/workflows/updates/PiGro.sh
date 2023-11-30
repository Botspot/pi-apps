#!/bin/bash

webVer=$(get_release_raw actionschnitzel/PiGro-Aid-)
all_url="https://github.com/actionschnitzel/PiGro-Aid-/releases/download/${webVer}/pigro-jci-${webVer}.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh