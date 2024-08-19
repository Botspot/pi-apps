#!/bin/bash

webVer="$(wget -qO- -t 5 --waitretry=10 --timeout=10 --retry-connrefused https://linux.wps.cn/ | grep -o 'wps\-office_.*_arm64\.deb' | sed 's/^wps\-office_//g' | sed 's/_arm64\.deb//g' | head -n1)"

#custom url 'encryption' function added by wps to prevent abuse
time="$(date +%s)"
secrityKey="$(wget -qO- -t 5 --waitretry=10 --timeout=10 --retry-connrefused https://linux.wps.cn | grep 'secrityKey =' | sed 's/.* "//g ; s/";$//g')" #lol typo
url="/wps/download/ep/Linux2019/$(echo $webVer | sed 's/.*\.//g')/wps-office_${webVer}_arm64.deb"
url="https://wps-linux-personal.wpscdn.cn$url?t=${time}&k=$(echo -n "$secrityKey$url$time" | md5sum | awk '{print $1}')"

arm64_url="$url"
armhf_url="$url"

# custom validate url function
# this will not overwrite the validate_url function created by the main update_apps.yml file for other update scripts
function validate_url(){
    if command wget -t 5 --waitretry=10 --timeout=10 --retry-connrefused -q --spider --header="User-Agent: This download is a result of the Pi-Apps store. Please stop blocking us. Please contact us if you have any questions. https://github.com/Botspot/pi-apps/issues/new/choose" "$1"; then
        return 0
    else
        return 1
    fi
}

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
