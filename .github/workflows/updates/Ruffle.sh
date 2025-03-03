#!/bin/bash

TAG=$(curl -s "https://api.github.com/repos/ruffle-rs/ruffle/releases/latest" | jq -r '.tag_name')
webVer="nightly-$(date -d "$(echo $TAG | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')" +'%Y-%m-%d')"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
