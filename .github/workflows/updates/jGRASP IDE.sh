#!/bin/bash

# The format of the returned data is:
#    final;last_major;location:final_bundled;last_major;location:non-final;last_major;location:non-final_bundled;last_major;location
# if there is a non-final release available 
# 
# and:
#    final;last_major;location:final_bundled;last_major;location
# if there is only a final release available.

version=$(wget -qO- https://spider.eng.auburn.edu/user-cgi/grasp/version7.pl | awk -F '[;:]' '{ print $3 } { if ($7) print $9 }' | tail -n 1 | sed 's;/dl4g/jgrasp/jgrasp;;g')

all_url="https://www.jgrasp.org/dl4g/jgrasp/jgrasp${version}.zip"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
