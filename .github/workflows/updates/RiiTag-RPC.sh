#!/bin/bash

webVer=$(get_release_raw RiiConnect24/riitag-rpc)
arm64_url="https://github.com/riiconnect24/riitag-rpc/releases/download/${webVer}/RiiTag-RPC_Rpi4B"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
