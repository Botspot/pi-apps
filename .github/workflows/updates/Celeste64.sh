#!/bin/bash

version=$(get_release ExOK/Celeste64)

armhf_url="https://github.com/ExOK/Celeste64/releases/download/v$version/Celeste64-v$version-Linux-arm.zip"
arm64_url="https://github.com/ExOK/Celeste64/releases/download/v$version/Celeste64-v$version-Linux-arm64.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
