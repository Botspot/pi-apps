#!/bin/bash

version=$(get_release mfat/systemd-pilot).0
armhf_url="https://github.com/mfat/systemd-pilot/releases/download/v3.0/systemd-pilot_${version}-1_all.deb"
arm64_url="https://github.com/mfat/systemd-pilot/releases/download/v3.0/systemd-pilot_${version}-1_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
