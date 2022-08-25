#!/bin/bash

webVer="$(wget -qO- https://apt.raspbian-addons.org/debian/pool/main/t/tetris-cli/ | grep -m 1 "tetris.*armhf.deb" | sed 's/.*tetris-cli_//g; s/_armhf.*//g')"
armhf_url="https://apt.raspbian-addons.org/debian/pool/main/t/tetris-cli/tetris-cli_${webVer}_armhf.deb"
arm64_url="https://apt.raspbian-addons.org/debian/pool/main/t/tetris-cli/tetris-cli_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh