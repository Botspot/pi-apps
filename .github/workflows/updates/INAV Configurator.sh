#!/bin/bash

version=$(get_release iNavFlight/inav-configurator-nightly)
arm64_url="https://github.com/iNavFlight/inav-configurator-nightly/releases/download/${version}/INAV-Configurator_linux_arm64_8.0.0.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
