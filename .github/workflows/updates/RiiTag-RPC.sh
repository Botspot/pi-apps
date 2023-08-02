#!/bin/bash

webVer=$(get_release_raw RiiConnect24/riitag-rpc)
arm64_url="https://github.com/riiconnect24/riitag-rpc/releases/download/${webVer}/rpi-4b-aarch64.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
