#!/bin/bash

version=$(get_release AndreRH/hangover)
arm64_url="https://github.com/AndreRH/hangover/releases/download/${version}/$(echo "$version" | sed 's/hangover-/hangover_/g')_debian13_trixie_arm64.tar"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
