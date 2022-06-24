#!/bin/bash

webVer="$(curl -sLI -o /dev/null -w %{url_effective} https://aka.ms/linux-armhf-deb | grep -o '_.*-' | sed 's/_\|-//g')"
armhf_url="https://update.code.visualstudio.com/${webVer}/linux-deb-armhf/stable"
arm64_url="https://update.code.visualstudio.com/${webVer}/linux-deb-arm64/stable"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
