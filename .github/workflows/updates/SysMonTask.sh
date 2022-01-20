#!/bin/bash

webVer="$(wget -qO- https://apt.raspbian-addons.org/debian/pool/main/s/sysmontask/ | grep -m 1 "sysmontask.*all.deb" | sed 's/.*sysmontask_//g; s/_all.*//g')"
all_url="https://apt.raspbian-addons.org/debian/pool/main/s/sysmontask/sysmontask_${webVer}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh