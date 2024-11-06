#!/bin/bash

version=$(get_release godotengine/godot)
armhf_url=https://github.com/godotengine/godot/releases/download/${version}/Godot_v${version}_linux.arm32.zip
arm64_url=https://github.com/godotengine/godot/releases/download/${version}/Godot_v${version}_linux.arm64.zip

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
