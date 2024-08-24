#!/bin/bash

version=$(get_release ArmCord/ArmCord)
armhf_url="https://github.com/ArmCord/ArmCord/releases/download/v${version}/ArmCord-${version%-*}-linux-armv7l.deb"
arm64_url="https://github.com/ArmCord/ArmCord/releases/download/v${version}/ArmCord-${version%-*}-linux-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh