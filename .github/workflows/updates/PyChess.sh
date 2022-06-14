#!/bin/bash

webVer="$(get_release pychess/pychess)"

all_url="https://github.com/pychess/pychess/releases/download/${webVer}/python3-pychess_${webVer}-1_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
