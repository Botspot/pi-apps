#!/bin/bash

webVer="$(get_release vscodium/vscodium)"
armhf_url="https://github.com/VSCodium/vscodium/releases/download/${webVer}/codium_${webVer}_armhf.deb"
arm64_url="https://github.com/VSCodium/vscodium/releases/download/${webVer}/codium_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
