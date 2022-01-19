#!/bin/bash

webVer="$(curl -s https://api.github.com/repos/VSCodium/vscodium/releases | grep -m 1 html_url | sed 's+.*tag/++g; s/[,"]//g')"
armhf_url="https://github.com/VSCodium/vscodium/releases/download/$(curl -s https://github.com/VSCodium/vscodium/releases/tag/${webVer} | grep "armhf.deb<" | awk -F '[<>]' '{print $3}')"
arm64_url="https://github.com/VSCodium/vscodium/releases/download/$(curl -s https://github.com/VSCodium/vscodium/releases/tag/${webVer} | grep "arm64.deb<" | awk -F '[<>]' '{print $3}')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh