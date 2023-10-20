#!/bin/bash

webVer[0]="$(get_release_raw veracrypt/VeraCrypt | sed 's/VeraCrypt_//g' )"
webVer[1]="${webVer[0]}"
armhf_url[0]="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_${webVer[0]}/veracrypt-${webVer[0]}-Debian-10-armhf.deb"
arm64_url[0]="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_${webVer[0]}/veracrypt-${webVer[0]}-Debian-10-arm64.deb"
armhf_url[1]="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_${webVer[1]}/veracrypt-${webVer[1]}-Debian-11-armhf.deb"
arm64_url[1]="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_${webVer[1]}/veracrypt-${webVer[1]}-Debian-11-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
