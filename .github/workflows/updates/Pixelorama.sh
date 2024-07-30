#!/bin/bash

version=$(get_release_raw Orama-Interactive/Pixelorama)
arm64_url="https://github.com/Orama-Interactive/Pixelorama/releases/download/${version}/Pixelorama-Linux-ARM64.tar.gz"
armhf_url="https://github.com/Orama-Interactive/Pixelorama/releases/download/${version}/Pixelorama-Linux-ARM32.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
