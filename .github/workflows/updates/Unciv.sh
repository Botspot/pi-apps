#!/bin/bash

webVer=$(get_release yairm210/Unciv)
all_url="https://github.com/yairm210/Unciv/releases/download/${webVer}/Unciv.jar"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
