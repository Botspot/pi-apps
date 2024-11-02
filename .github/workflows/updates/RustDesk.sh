#!/bin/bash

version=$(get_release rustdesk/rustdesk)
armhf_url="https://github.com/rustdesk/rustdesk/releases/download/${version}/rustdesk-${version}-armv7-sciter.deb"
arm64_url="https://github.com/rustdesk/rustdesk/releases/download/${version}/rustdesk-${version}-aarch64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
