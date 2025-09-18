#!/bin/bash

version=$(get_release davidk/PrusaSlicer-ARM.AppImage | sed "s/ersion_//g")
armhf_url="https://github.com/davidk/PrusaSlicer-ARM.AppImage/releases/download/version_${version}/PrusaSlicer-version_${version}-armhf.AppImage"
arm64_url="https://github.com/davidk/PrusaSlicer-ARM.AppImage/releases/download/version_${version}/PrusaSlicer-${version}-aarch64-full.AppImage"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
