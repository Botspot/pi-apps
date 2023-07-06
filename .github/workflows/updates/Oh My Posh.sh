#!/bin/bash

webVer=$(get_release_raw JanDeDobbeleer/oh-my-posh)
arm64_url="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${webVer}/posh-linux-arm64"
armhf_url="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${webVer}/posh-linux-arm"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
