#!/bin/bash

webVer="$(wget -qO- https://apt.raspbian-addons.org/debian/pool/main/s/stuntrally/ | grep -m 1 "stuntrally.*armhf.deb" | grep -o '_.*_' | tr -d '_')"
armhf_url="https://apt.raspbian-addons.org/debian/pool/main/s/stuntrally/stuntrally_${webVer}_armhf.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
