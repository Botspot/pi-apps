#!/bin/bash

version=$(wget -qO - https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/dists/antigravity-debian/main/binary-arm64/Packages | grep '^Package:\|^Filename:' | grep '^Package: antigravity' -A1 | grep Filename: | sort -rV | head -n1 | sed 's+.*/++g')
arm64_url="https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/pool/antigravity-debian/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
