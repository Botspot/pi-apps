#!/bin/bash

version=$(get_release ShadowEngineTeam/FNF-Shadow-Engine)
armhf_url="https://github.com/ShadowEngineTeam/FNF-Shadow-Engine/releases/download/${version}/ShadowEngine-ASTC-linux-armv7.tar"
arm64_url="https://github.com/ShadowEngineTeam/FNF-Shadow-Engine/releases/download/${version}/ShadowEngine-ASTC-linux-arm64.tar"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
