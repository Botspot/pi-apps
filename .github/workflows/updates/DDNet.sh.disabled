#!/bin/bash

webVer=$(wget -qO- https://info2.ddnet.tw/info | jq -r '.version')
all_url="https://github.com/ddnet/ddnet/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
