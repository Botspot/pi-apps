#!/bin/bash

webVer=$(get_release obsidianmd/obsidian-releases)
arm64_url="https://github.com/obsidianmd/obsidian-releases/releases/download/v${webVer}/obsidian-${webVer}-arm64.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
