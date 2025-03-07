#!/bin/bash

version=$(get_prerelease ruffle-rs/ruffle)
all_url="https://github.com/ruffle-rs/ruffle/releases/download/${version}/ruffle-${version}-reproducible-source.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
