#!/bin/bash

#version=$(wget -qO- https://www.geekbench.com/download/linux/ | grep "for Linux. If your download does not start in"  | sed "s/ for Linux.*//g ; s/.* //g")
version=$(wget -qO- "https://formulae.brew.sh/api/cask/geekbench.json" | tr ':,' '\n' | grep -x '"version"' -A1 | grep '^"6\.' | tr -d '"')
arm64_url="https://cdn.geekbench.com/Geekbench-${version}-LinuxARMPreview.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
