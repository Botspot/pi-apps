#!/bin/bash

version=$(curl -Ls 'https://spider.eng.auburn.edu/user-cgi/grasp/grasp.pl?;dl=download_jgrasp.html' | grep "jGRASP - Version" | sed 's/.*jGRASP - Version //' | sed 's/<br>//' | tr -d .)

all_url="https://www.jgrasp.org/dl4g/jgrasp/jgrasp${version}.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
