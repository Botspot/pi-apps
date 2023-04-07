#!/bin/bash

webVer=$(get_release Guake/guake)
all_url="https://github.com/Guake/guake/tree/$webVer"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
