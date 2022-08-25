#!/bin/bash

webVer="$(wget -qO- https://apt.raspbian-addons.org/debian/pool/main/b/blockbench/ | grep -m 1 "blockbench.*armhf.deb" | grep -o '_.*_' | tr -d '_')"
armhf_url="https://apt.raspbian-addons.org/debian/pool/main/b/blockbench/blockbench_${webVer}_armhf.deb"
arm64_url="https://apt.raspbian-addons.org/debian/pool/main/b/blockbench/blockbench_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
