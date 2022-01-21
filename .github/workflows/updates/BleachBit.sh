#!/bin/bash


webVer="$(wget -qO- https://www.bleachbit.org/download/linux | grep "Debian 11 (Bullseye)" | sed 's+.*/download/file/t?file=bleachbit_++g; s/_all.*//g')"
all_url="https://download.bleachbit.org/bleachbit_${webVer}_all_debian11.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
