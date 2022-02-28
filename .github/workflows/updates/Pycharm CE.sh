#!/bin/bash

webVer="$(curl -s 'https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=release&build=&_=1642490536688'   -H 'authority: data.services.jetbrains.com'   -H 'sec-ch-ua: "Chromium";v="95", ";Not A Brand";v="99"'   -H 'accept: application/json, text/javascript, */*; q=0.01'   -H 'sec-ch-ua-mobile: ?0'   -H 'user-agent: Mozilla/5.0 (X11; CrOS armv7l 13597.84.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.78 Safari/537.36'   -H 'sec-ch-ua-platform: "Linux"'   -H 'origin: https://www.jetbrains.com'   -H 'sec-fetch-site: same-site'   -H 'sec-fetch-mode: cors'   -H 'sec-fetch-dest: empty'   -H 'referer: https://www.jetbrains.com/'   -H 'accept-language: en-US,en;q=0.9'   --compressed | jq | grep -m 1 version  | sed 's/.*: //g; s/,//g; s/"//g')"
all_url="https://download.jetbrains.com/python/pycharm-community-${webVer}.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh