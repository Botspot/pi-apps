#!/bin/bash

version=$(get_release notepad-plus-plus/notepad-plus-plus)
armhf_url="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${version}/npp.${version}.portable.zip"
arm64_url="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${version}/npp.${version}.portable.x64.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
