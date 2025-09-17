#!/bin/bash

version=$(get_release FreeCAD/FreeCAD)
arm64_url="https://github.com/FreeCAD/FreeCAD/releases/download/${version}/FreeCAD_${version}-conda-Linux-aarch64-py311.AppImage"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
