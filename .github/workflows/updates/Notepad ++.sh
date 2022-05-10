#!/bin/bash

webVer=$(wget -qO- https://notepad-plus-plus.org/ | grep 'Current Version' | sed 's/.*Current Version //g' | sed 's+<.*++g')
armhf_url="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${webVer}/npp.${webVer}.portable.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
