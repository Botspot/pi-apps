#!/bin/bash

version=$(wget -qO- https://raw.githubusercontent.com/flathub/com.boxy_svg.BoxySVG/master/com.boxy_svg.BoxySVG.yaml | grep 'url: https://storage.boxy-svg.com/flathub' | sed 's/.*url: //g'  | tr '?-' '\n' | grep '\.zip$')
all_url="https://storage.boxy-svg.com/flathub/app-${version}"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
