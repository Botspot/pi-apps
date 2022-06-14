#!/bin/bash

webVer=$(get_release 00-Evan/shattered-pixel-dungeon)
all_url="https://github.com/00-Evan/shattered-pixel-dungeon/releases/download/v${webVer}/ShatteredPD-v${webVer}-Desktop.jar"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh