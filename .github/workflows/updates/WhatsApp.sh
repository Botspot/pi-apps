#!/bin/bash

webVer=$(get_release cycool29/whatsapp-for-linux)
armhf_url="https://github.com/cycool29/whatsapp-for-linux/releases/download/${webVer}/whatsapp_${webVer}_armhf.deb"
arm64_url="https://github.com/cycool29/whatsapp-for-linux/releases/download/${webVer}/whatsapp_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
