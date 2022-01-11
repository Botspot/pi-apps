#!/bin/bash

webVer=$(get_release angryip/ipscan)
all_url="https://github.com/angryip/ipscan/releases/download/${webVer}/ipscan_${webVer}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh