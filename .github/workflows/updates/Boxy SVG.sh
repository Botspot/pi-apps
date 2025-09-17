#!/bin/bash

version=$(wget -qO- https://raw.githubusercontent.com/flathub/com.boxy_svg.BoxySVG/master/com.boxy_svg.BoxySVG.yaml | grep 'https://storage\.boxy-svg\.com/builds/.*arm64\.zip$' -o | awk -F- '{print $4}')
all_url="https://storage.boxy-svg.com/builds/boxy-svg-${version}-linux-arm64.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
