#!/bin/bash

webVer=$(get_release Ulauncher/Ulauncher)
all_url="https://github.com/Ulauncher/Ulauncher/releases/download/${webVer}/ulauncher_${webVer}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh