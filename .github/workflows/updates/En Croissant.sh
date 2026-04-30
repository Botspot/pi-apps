#!/bin/bash

version=$(get_release ferranox/en-croissant-rpi)
all_url="https://github.com/ferranox/en-croissant-rpi/archive/refs/tags/v${version}.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
