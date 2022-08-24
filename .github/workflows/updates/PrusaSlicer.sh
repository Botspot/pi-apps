#!/bin/bash

webVer=$(get_release davidk/PrusaSlicer-ARM.AppImage | sed "s/ersion_//g")
armhf_url="https://github.com/davidk/PrusaSlicer-ARM.AppImage/releases/download/version_${webVer}/PrusaSlicer-version_${webVer}-armhf.AppImage"
arm64_url="https://github.com/davidk/PrusaSlicer-ARM.AppImage/releases/download/version_${webVer}/PrusaSlicer-version_${webVer}-aarch64.AppImage"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh