#!/bin/bash

webVer="$(wget -qO- https://www.worldpainter.net/ | grep -m 1 "worldpainter_.*.deb" | grep -o '_.*.deb' | tr -d '_' | sed 's/.deb//')"
all_url="https://www.worldpainter.net/files/worldpainter_${webVer}.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
