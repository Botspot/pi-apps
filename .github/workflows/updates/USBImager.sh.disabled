#!/bin/bash

webVer="$(wget -qO- https://gitlab.com/bztsrc/usbimager/-/raw/master/README.md | grep Raspberry | grep X11 | sed 's/-armv7l.*//g; s/.*usbimager_//g')"
armhf_url="https://gitlab.com/bztsrc/usbimager/raw/binaries/usbimager_${webVer}-armv7l-linux-x11.zip"
arm64_url="https://gitlab.com/bztsrc/usbimager/raw/binaries/usbimager_${webVer}-aarch64-linux-x11.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh