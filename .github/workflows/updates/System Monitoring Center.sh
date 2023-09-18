webVer[0]=$(curl -s --header "Authorization: token $GH_PERSONAL_ACCESS_TOKEN" "https://api.github.com/repos/hakandundar34coding/system-monitoring-center/releases" | jq -r 'map(select(.prerelease==false)) | map(select(.draft==false)) | map(select(.tag_name | startswith("v2."))) | first | .tag_name' | sed s/^v//g)
all_url[0]="https://github.com/hakandundar34coding/system-monitoring-center/releases/download/v${webVer[0]}/system-monitoring-center_${webVer[0]}_all.deb"
webVer[1]=$(curl -s --header "Authorization: token $GH_PERSONAL_ACCESS_TOKEN" "https://api.github.com/repos/hakandundar34coding/system-monitoring-center/releases" | jq -r 'map(select(.prerelease==false)) | map(select(.draft==false)) | map(select(.tag_name | startswith("v1."))) | first | .tag_name' | sed s/^v//g)
all_url[1]="https://github.com/hakandundar34coding/system-monitoring-center/releases/download/v${webVer[1]}/system-monitoring-center_${webVer[1]}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
