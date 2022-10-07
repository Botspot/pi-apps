#!/bin/bash

webVer="$(wget https://support.ekioh.com/download -qO- | grep '<div class="download-link-container">' -A 1 | tail -1 | grep -o 'binaries.*\.zip' | sed 's+^binaries/++ ; s/\.zip//')"
arm64_url="https://support.ekioh.com/download/binaries/${webVer}.zip"
armhf_url="$(sed 's/pi64/pi32/g' <<<"$arm64_url")"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
