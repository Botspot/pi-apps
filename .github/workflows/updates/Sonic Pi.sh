#!/bin/bash

version[0]=$(curl -sL https://github.com/sonic-pi-net/sonic-pi/releases/latest | grep -m 1 bookworm.arm64.deb | sed 's/.*sonic-pi_//g; s/_bookworm\.arm64.*//g')
version[1]=$(curl -sL https://github.com/sonic-pi-net/sonic-pi/releases/latest | grep -m 1 trixie.arm64.deb | sed 's/.*sonic-pi_//g; s/_trixie\.arm64.*//g')
arm64_url[0]="https://sonic-pi.net/files/releases/v${version[0]%_*}/sonic-pi_${version[0]}_bookworm.arm64.deb"
arm64_url[1]="https://sonic-pi.net/files/releases/v${version[1]%_*}/sonic-pi_${version[1]}_trixie.arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
