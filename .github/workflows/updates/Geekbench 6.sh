#!/bin/bash

webVer=$(wget -qO- https://www.geekbench.com/download/linux/ | grep "for Linux. If your download does not start in"  | sed "s/ for Linux.*//g ; s/.* //g")
arm64_url="https://cdn.geekbench.com/Geekbench-${webVer}-LinuxARMPreview.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
