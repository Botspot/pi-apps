#!/bin/bash

webVer=$(curl -s "https://gitlab.com/api/v4/projects/44042130/releases" | tr '{},[]' '\n' | grep -x '"direct_asset_url":.*linux-arm64-package.tar.bz2"' -m1 | sed 's+.*/packages/generic/librewolf/++g ; s+/.*++g')
arm64_url="https://gitlab.com/api/v4/projects/44042130/packages/generic/librewolf/${webVer}/librewolf-${webVer}-linux-arm64-package.tar.bz2"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
