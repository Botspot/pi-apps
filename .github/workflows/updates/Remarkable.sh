#!/bin/bash

webVer="$(get_release jamiemcg/Remarkable)"

all_url="https://remarkableapp.github.io/files/remarkable_${version}.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
