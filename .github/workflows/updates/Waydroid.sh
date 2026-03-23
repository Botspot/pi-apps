#!/bin/bash

version=$(wget -qO - https://repo.waydro.id/dists/bookworm/main/binary-all/Packages | grep '^Package:\|^Filename:' | grep '^Package: waydroid' -A1 | grep Filename: | sort -rV | head -n1 | sed 's+.*/++g')
arm64_url="https://repo.waydro.id/dists/bookworm/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
