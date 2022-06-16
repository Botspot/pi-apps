#!/bin/bash

webVer=$(get_release processing/processing4)
armhf_url="https://github.com/processing/processing4/releases/download/${webVer}/processing-$(echo ${webVer} | awk '{n=split($1,A,"-"); print A[n]}')-linux-arm32.tgz"
arm64_url="https://github.com/processing/processing4/releases/download/${webVer}/processing-$(echo ${webVer} | awk '{n=split($1,A,"-"); print A[n]}')-linux-arm64.tgz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
