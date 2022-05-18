webVer=$(get_release hakandundar34coding/system-monitoring-center | sed 's/[^0-9.]*//g')
all_url="https://github.com/hakandundar34coding/system-monitoring-center/releases/download/v${webVer}-deb_for_stores/system-monitoring-center_${webVer}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh