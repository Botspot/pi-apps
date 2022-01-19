#!/bin/bash

webVer=$(get_release browsh-org/browsh)
armhf_url="https://github.com/browsh-org/browsh/releases/download/v${webVer}/browsh_${webVer}_linux_armv7.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
