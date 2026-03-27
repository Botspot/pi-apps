#!/bin/bash

version=$(get_release kovidgoyal/kitty)
arm64_url="https://github.com/kovidgoyal/kitty/releases/download/v${version}/kitty-${version}-${ARCH}.txz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
