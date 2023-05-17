#!/bin/bash

webVer="$(wget https://support.ekioh.com/download -qO- | grep '<div class="download-link-container">' -A 1 | grep pi64 | tail -1 | grep -o 'binaries.*\.zip' | sed 's+^binaries/++ ; s/\.zip//')"
arm64_url="https://support.ekioh.com/download/binaries/${webVer}.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh

webVer="$(wget https://support.ekioh.com/download -qO- | grep '<div class="download-link-container">' -A 1 | grep pi32 | tail -1 | grep -o 'binaries.*\.zip' | sed 's+^binaries/++ ; s/\.zip//')"
armhf_url="https://support.ekioh.com/download/binaries/${webVer}.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
