#!/bin/bash

webVer="$(wget --header="Accept: text/html" --user-agent="Linux" -qO- https://sourceforge.net/projects/veracrypt/files/ | sed -n '/Latest/{n;p;}' | sed 's/.*veracrypt-//g; s/-setup.*//g')"
armhf_url="https://sourceforge.net/projects/veracrypt/files/VeraCrypt%20${webVer}/Linux/veracrypt-${webVer}-Debian-10-armhf.deb"
arm64_url="https://sourceforge.net/projects/veracrypt/files/VeraCrypt%20${webVer}/Linux/veracrypt-${webVer}-Debian-10-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh