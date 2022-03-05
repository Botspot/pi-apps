#!/bin/bash

webVer="$(wget -qO- "https://software.opensuse.org//download.html?project=home%3AIBBoard%3Acawbird&package=cawbird" | grep -m 1 "Raspbian.*deb" | sed 's/.*Raspbian_10//g' | grep -o '_.*_' | tr -d '_')"
armhf_url="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Raspbian_10/armhf/cawbird_${webVer}_armhf.deb"
arm64_url="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Raspbian_10/arm64/cawbird_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh

