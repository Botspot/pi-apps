#!/bin/bash

webVer=$(wget -qO- https://www.geekbench.com/download/linux/ | grep "You are downloading" | sed "s/.*You are downloading Geekbench //g; s/ for Linux.*//g")
armhf_url="https://cdn.geekbench.com/Geekbench-${webVer}-LinuxARMPreview.tar.gz"
arm64_url="https://cdn.geekbench.com/Geekbench-${webVer}-LinuxARMPreview.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
