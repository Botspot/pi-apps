#!/bin/bash

webVer=$(get_release_raw MoneroOcean/xmrig)
all_url="https://github.com/MoneroOcean/xmrig/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
