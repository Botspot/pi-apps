webVer=$(curl -s --header "Authorization: token ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}" "https://api.github.com/repos/hakandundar34coding/system-monitoring-center/releases" | jq -r 'map(select(.prerelease==false)) | map(select(.draft==false)) | map(select(.tag_name | startswith("v1."))) | first | .tag_name' | sed s/^v//g)
all_url="https://github.com/hakandundar34coding/system-monitoring-center/releases/download/v${webVer}/system-monitoring-center_${webVer}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
