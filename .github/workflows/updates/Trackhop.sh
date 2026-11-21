#!/bin/bash

# Trackhop Desktop's releases are tagged server-v<version> (GitHub's "latest" release is its Android app).
webVer=$(curl -s --header "Authorization: token $GH_PERSONAL_ACCESS_TOKEN" "https://api.github.com/repos/xlollx/Trackhop/releases" | jq -r 'map(select(.draft==false)) | map(select(.tag_name | startswith("server-v"))) | first | .tag_name' | sed s/^server-v//g)
arm64_url="https://github.com/xlollx/Trackhop/releases/download/server-v${webVer}/Trackhop-Desktop-v${webVer}-linux-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
