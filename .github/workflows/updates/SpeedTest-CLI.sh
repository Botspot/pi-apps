#!/bin/bash

armhf_webPackages="https://packagecloud.io/ookla/speedtest-cli/ubuntu/dists/bionic/main/binary-armhf/Packages"
arm64_webPackages="https://packagecloud.io/ookla/speedtest-cli/ubuntu/dists/bionic/main/binary-arm64/Packages"
armhf_packagename="speedtest"
arm64_packagename="speedtest"

# The corresponding appname in pi-apps will have its corresponding filepath= variable update
# the filepath variable will contain the full filepath of the debian package with the version included

source $GITHUB_WORKSPACE/.github/workflows/update_debian_repo_script.sh
