#!/bin/bash

webVer=$(get_release Aster-Privacy/Aster-Mail)
arm64_url="https://github.com/Aster-Privacy/Aster-Mail/releases/download/v${webVer}/Aster.Mail_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
