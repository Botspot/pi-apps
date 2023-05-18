#!/bin/bash

webVer=$(get_release_raw lakinduakash/linux-wifi-hotspot)
all_url="https://github.com/lakinduakash/linux-wifi-hotspot/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
