#!/bin/bash

version=$(get_release Legcord/Legcord)
armhf_url="https://github.com/Legcord/Legcord/releases/download/v${version}/Legcord-${version%-*}-linux-armv7l.deb"
arm64_url="https://github.com/Legcord/Legcord/releases/download/v${version}/Legcord-${version%-*}-linux-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh