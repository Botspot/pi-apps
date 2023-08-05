#!/bin/bash

webVer=$(get_release Open-Typer/Open-Typer)
armhf_url="https://github.com/Open-Typer/Open-Typer/releases/download/v${webVer}/Open-Typer-armhf.AppImage"
arm64_url="https://github.com/Open-Typer/Open-Typer/releases/download/v${webVer}/Open-Typer-aarch64.AppImage"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
