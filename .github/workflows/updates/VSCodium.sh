#!/bin/bash

webVer="$(get_release vscodium/vscodium)"
armhf_url="https://github.com/VSCodium/vscodium/releases/download/${webVer}/codium_$(wget -qO- https://github.com/VSCodium/vscodium/releases/tag/${webVer} | grep 'armhf.deb"' | grep -o "_.*_" | tr -d '_')_armhf.deb"
arm64_url="https://github.com/VSCodium/vscodium/releases/download/${webVer}/codium_$(wget -qO- https://github.com/VSCodium/vscodium/releases/tag/${webVer} | grep 'arm64.deb"' | grep -o "_.*_" | tr -d '_')_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
