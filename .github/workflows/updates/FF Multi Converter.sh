#!/bin/bash

webVer=$(get_release l-koehler/FF-converter)
all_url="https://github.com/l-koehler/FF-converter/releases/download/v${webVer}/ffconverter-${webVer}.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh