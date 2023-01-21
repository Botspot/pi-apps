#!/bin/bash

webVer=$(wget -qO- https://www.ratrabbit.nl/ratrabbit/xsnow/downloads/index.html | grep -A1 "Download source:" | tail -n 1  | sed 's/<p>//g ; s+</p>++g' | sed 's+"./../../../downloads/xsnow/xsnow-.*tar.gz">++g ; s+</a>++g' | grep -oP '^[^-]*\-\K[^*]+' | sed -n 's/.tar.gz//p')
all_url="https://www.ratrabbit.nl/downloads/xsnow/xsnow-${webVer}.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
