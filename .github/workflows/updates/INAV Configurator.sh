#!/bin/bash

version=$(get_release iNavFlight/inav-configurator)
arm64_url="https://github.com/iNavFlight/inav-configurator/releases/download/${version}/INAV-Configurator_linux_arm64_${version}.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
