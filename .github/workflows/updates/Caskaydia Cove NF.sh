#!/bin/bash

webVer=$(get_release_raw ryanoasis/nerd-fonts)
all_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${webVer}/CascadiaCode.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
