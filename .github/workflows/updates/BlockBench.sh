#!/bin/bash

webVer=$(get_release JannisX11/blockbench)
armhf_url="https://github.com/ryanfortner/blockbench-arm/raw/master/blockbench_${webVer}_armhf.deb"
arm64_url="https://github.com/ryanfortner/blockbench-arm/raw/master/blockbench_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
