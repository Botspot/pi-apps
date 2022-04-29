#!/bin/bash

# specify the webVer method (commonly used when getting releases from github actions)
# webVer="$(wget -qO- https://apt.syncthing.net/dists/syncthing/stable/binary-armhf/Packages | awk '/Package: syncthing\n/' RS= | grep "Version:" | awk '{print $2}' | sort -V | tail -n1)"
# armhf_url="https://apt.syncthing.net/dists/syncthing/stable/binary-armhf/syncthing_${webVer}_armhf.deb"

# source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh

# new method written specifically for reading apt repo Packages file
# this script method automatically obtains the Version: and Filename: from the online Packages file

armhf_webPackages="https://apt.syncthing.net/dists/syncthing/stable/binary-armhf/Packages"
arm64_webPackages="https://apt.syncthing.net/dists/syncthing/stable/binary-arm64/Packages"
armhf_packagename="syncthing"
arm64_packagename="syncthing"

# The corresponding appname in pi-apps will have its corresponding filepath= variable update
# the filepath variable will contain the full filepath of the debian package with the version included

source $GITHUB_WORKSPACE/.github/workflows/update_debian_repo_script.sh