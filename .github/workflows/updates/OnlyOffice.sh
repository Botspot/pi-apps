#!/bin/bash

version=$(get_release ONLYOFFICE/DesktopEditors)
arm64_url="https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
