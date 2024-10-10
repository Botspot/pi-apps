
#!/bin/bash

version=$(get_release_raw dhewm/dhewm3)
arm64_url="https://github.com/dhewm/dhewm3/tree/$version"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh