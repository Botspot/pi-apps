#!/bin/bash

version=$(get_prerelease ruffle-rs/ruffle)
filename_version="${version//-/_}"
all_url="https://github.com/ruffle-rs/ruffle/releases/download/${version}/ruffle-${filename_version}-linux-aarch64.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
