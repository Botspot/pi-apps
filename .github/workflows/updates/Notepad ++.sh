#!/bin/bash

webVer=$(get_release notepad-plus-plus/notepad-plus-plus)
armhf_url="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${webVer}/npp.${webVer}.portable.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh