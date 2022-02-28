#!/bin/bash

webVer=$(wget -qO- https://www.speedtest.net/apps/cli | grep -o ".*-linux-armhf.tgz" | sed 's+.*armel</a></li><li><a href="++g' | sed 's/.*ookla-speedtest-//g; s/-linux-armhf.tgz//g')
armhf_url="https://install.speedtest.net/app/cli/ookla-speedtest-$webVer-linux-armhf.tgz"
arm64_url="https://install.speedtest.net/app/cli/ookla-speedtest-$webVer-linux-aarch64.tgz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
