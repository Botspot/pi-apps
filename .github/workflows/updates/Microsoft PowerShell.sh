#!/bin/bash

webVer=$(get_release PowerShell/PowerShell)
armhf_url="https://github.com/PowerShell/PowerShell/releases/download/v${webVer}/powershell-${webVer}-linux-arm32.tar.gz"
arm64_url="https://github.com/PowerShell/PowerShell/releases/download/v${webVer}/powershell-${webVer}-linux-arm64.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh