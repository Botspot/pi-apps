#!/bin/bash

webVer=$(curl -s "https://codeberg.org/api/v1/repos/librewolf/bsys6/releases" | tr '{},[]' '\n' | grep -x '"tag_name":"[^"]*"' -m1 | sed 's/"tag_name":"//;s/"$//')
arm64_url="https://codeberg.org/api/packages/librewolf/generic/librewolf/${webVer}/librewolf-${webVer}-linux-arm64-package.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh