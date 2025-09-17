#!/bin/bash

webVer="$(wget -qO- https://www.arduino.cc/en/software | grep md5sum.txt | sed s/.md5sum.txt.*//g | sed 's+.*href="//downloads.arduino.cc/arduino-++g')"
armhf_url="https://downloads.arduino.cc/arduino-${webVer}-linuxarm.tar.xz"
arm64_url="https://downloads.arduino.cc/arduino-${webVer}-linuxaarch64.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
