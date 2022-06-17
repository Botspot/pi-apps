#!/bin/bash

# raspbian 10
webVer[0]=$(wget -qO- "https://software.opensuse.org//download.html?project=home%3AIBBoard%3Acawbird&package=cawbird" | grep -m 1 "Raspbian_10.*armhf.deb" | sed 's/.*Raspbian_10//g' | grep -o '_.*_' | tr -d '_')
# debian 11
webVer[1]=$(wget -qO- "https://software.opensuse.org//download.html?project=home%3AIBBoard%3Acawbird&package=cawbird" | grep -m 1 "Debian_11.*armhf.deb" | sed 's/.*Debian_11//g' | grep -o '_.*_' | tr -d '_')
# ubuntu focal
webVer[2]=$(wget -qO- "https://software.opensuse.org//download.html?project=home%3AIBBoard%3Acawbird&package=cawbird" | grep -m 1 "xUbuntu_20.04.*armhf.deb" | sed 's/.*xUbuntu_20.04//g' | grep -o '_.*_' | tr -d '_')
# ubuntu bionic
webVer[3]=$(wget -qO- "https://software.opensuse.org//download.html?project=home%3AIBBoard%3Acawbird&package=cawbird" | grep -m 1 "Ubuntu_18.04_Ports.*armhf.deb" | sed 's/.*Ubuntu_18.04_Ports//g' | grep -o '_.*_' | tr -d '_')

armhf_url[0]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Raspbian_10/armhf/cawbird_${webVer[0]}_armhf.deb"
armhf_url[1]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Debian_11/armhf/cawbird_${webVer[1]}_armhf.deb"
armhf_url[2]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/xUbuntu_20.04/armhf/cawbird_${webVer[2]}_armhf.deb"
armhf_url[3]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Ubuntu_18.04_Ports/armhf/cawbird_${webVer[3]}_armhf.deb"
arm64_url[0]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Raspbian_10/arm64/cawbird_${webVer[0]}_arm64.deb"
arm64_url[1]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Debian_11/arm64/cawbird_${webVer[1]}_arm64.deb"
arm64_url[2]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/xUbuntu_20.04/arm64/cawbird_${webVer[2]}_arm64.deb"
arm64_url[3]="https://download.opensuse.org/repositories/home:/IBBoard:/cawbird/Ubuntu_18.04_Ports/arm64/cawbird_${webVer[3]}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
