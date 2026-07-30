#!/bin/bash

webVer="$(get_release vscodium/vscodium)"
# VSCodium no longer publishes armhf (32-bit ARM) .deb packages after v1.121.x.
# The install-32 script remains pinned to v1.121.03429 for existing 32-bit users.
arm64_url="https://github.com/VSCodium/vscodium/releases/download/${webVer}/codium_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
