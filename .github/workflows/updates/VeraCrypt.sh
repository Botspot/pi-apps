#!/bin/bash

webVer="$(wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36" -qO- https://sourceforge.net/projects/veracrypt/files/ | sed -n '/Latest/{n;p;}' | sed 's/.*veracrypt-//g; s/-setup.*//g')"
armhf_url="https://sourceforge.net/projects/veracrypt/files/VeraCrypt%20${webVer}/Linux/veracrypt-${webVer}-Debian-10-armhf.deb"
arm64_url="https://sourceforge.net/projects/veracrypt/files/VeraCrypt%20${webVer}/Linux/veracrypt-${webVer}-Debian-10-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
