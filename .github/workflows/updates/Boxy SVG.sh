#!/bin/bash

webVer=$(wget https://raw.githubusercontent.com/boxy-svg/boxy-svg-snap/master/snap/snapcraft.yaml -qO- | grep source: -m 1 | tr '?-' '\n' | grep '\.zip$')
all_url="https://firebasestorage.googleapis.com/v0/b/boxy-svg.appspot.com/o/linux%2Fapp-${webVer}?alt=media"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
