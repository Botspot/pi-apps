#!/bin/bash

version=$(curl -s https://registry.npmjs.org/@opencode/cli-linux-arm64/latest | jq -r '.version')
arm64_url="https://registry.npmjs.org/@opencode/cli-linux-arm64/-/cli-linux-arm64-${version}.tgz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
