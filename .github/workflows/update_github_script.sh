#!/bin/bash

# to run this script as part of other update scripts, source the directory like below
# source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh


# for apps with an install-32 file, make sure that you supply the following variables before sourcing this script (examples for webcord shown below)
# the ${version} variable within the url is important
# it is assumed that your install script will contain a version variable with the version of the app you would like to keep updated automatically

# version=$(get_release SpacingBat3/WebCord)
# armhf_url="https://github.com/SpacingBat3/WebCord/releases/download/v${version}/webcord_${version}_armhf.deb"

# for apps with an install-64 file, make sure that you supply the following variables before sourcing this script (examples for webcord shown below)
# if a variable is already set, no need to duplicate it

# version=$(get_release SpacingBat3/WebCord)
# arm64_url="https://github.com/SpacingBat3/WebCord/releases/download/v${version}/webcord_${version}_arm64.deb"

# for apps with a unified install file, make sure to supply the following variables before sourcing this script

# version=$(get_release subhra74/xdm)
# all_url="https://github.com/subhra74/xdm/releases/download/${version}/xdm-setup-${version}.tar.xz"

# for apps with a unified install file, you can alternatively use separate per architecture version variables before sourcing this script

# version_armhf=$(curl -s --header "Authorization: token $GH_PERSONAL_ACCESS_TOKEN" "https://api.github.com/repos/musescore/MuseScore/releases/latest" | jq -r '.assets | .[].browser_download_url' | grep armv7l.AppImage$ | sed 's;https://github.com/musescore/MuseScore/releases/download/v'.*'/MuseScore-Studio-;;g' | sed 's;-armv7l.AppImage;;g')
# version_arm64=$(curl -s --header "Authorization: token $GH_PERSONAL_ACCESS_TOKEN" "https://api.github.com/repos/musescore/MuseScore/releases/latest" | jq -r '.assets | .[].browser_download_url' | grep aarch64.AppImage$ | sed 's;https://github.com/musescore/MuseScore/releases/download/v'.*'/MuseScore-Studio-;;g' | sed 's;-aarch64.AppImage;;g')
# armhf_url="https://github.com/musescore/MuseScore/releases/download/v${version_armhf%.*}/MuseScore-Studio-${version_armhf}-armv7l.AppImage"
# arm64_url="https://github.com/musescore/MuseScore/releases/download/v${version_arm64%.*}/MuseScore-Studio-${version_arm64}-aarch64.AppImage"

# alternatively, this script also supports using the variable "webVer" instead of "version"
if [ -n "$version" ]; then
webVer=("${version[@]}")
fi

# set webVer to version_armhf for dummy loop
if [ -n "$version_armhf" ]; then
webVer=("${version_armhf[@]}")
fi

# make sure webVer variable is supplied by the sourcing script
if [ -n "$webVer" ]; then
#iterate through all webVer supplied if an array
for (( iter=0; iter<${#webVer[@]}; iter++ )); do
#make array appear as one variable inside for loop
webVer=${webVer[$iter]}
version_armhf=${version_armhf[$iter]}
version_arm64=${version_arm64[$iter]}
pi_apps_ver_32=${pi_apps_ver_32[$iter]}
pi_apps_ver_64=${pi_apps_ver_64[$iter]}
pi_apps_ver=${pi_apps_ver[$iter]}
armhf_url=${armhf_url[$iter]}
arm64_url=${arm64_url[$iter]}
all_url=${all_url[$iter]}
if [[ $iter == "0" ]]; then
    version_number=""
else
    version_number=$((iter + 1))
fi
# echo the versions
status "The latest online version is:  $webVer"

#set defaults for pi_app_ver if not supplied
if [ -z "$pi_apps_ver_32" ] && [ -n "$armhf_url" ] && [ -f install-32 ]; then
    pi_apps_ver_32="$(cat 'install-32' | grep -m 1 "version${version_number}=" | sed "s/version${version_number}=//" | xargs)"
fi

if [ -z "$pi_apps_ver_64" ] && [ -n "$arm64_url" ] && [ -f install-64 ]; then
    pi_apps_ver_64="$(cat 'install-64' | grep -m 1 "version${version_number}=" | sed "s/version${version_number}=//" | xargs)"
fi

if [ -z "$pi_apps_ver" ] && [ -n "$all_url" ] && [ -f install ]; then
    pi_apps_ver="$(cat 'install' | grep -m 1 "version${version_number}=" | sed "s/version${version_number}=//" | xargs)"
fi

# check for armhf and arm64 URL with a single install script using different versions
if [ -z "$pi_apps_ver" ] && [ -z "$pi_apps_ver_32" ] && [ -z "$pi_apps_ver_64" ] && [ -n "$armhf_url" ] && [ -n "$arm64_url" ] && [ -n "$version_armhf" ] && [ -n "$version_arm64" ] && [ -f install ]; then
    pi_apps_ver_32="$(cat 'install' | grep -m 1 "version_armhf${version_number}=" | sed "s/version_armhf${version_number}=//" | xargs)"
    pi_apps_ver_64="$(cat 'install' | grep -m 1 "version_arm64${version_number}=" | sed "s/version_arm64${version_number}=//" | xargs)"
fi

# check for armhf and arm64 URL with a single install script using the same version
if [ -z "$pi_apps_ver" ] && [ -z "$pi_apps_ver_32" ] && [ -z "$pi_apps_ver_64" ] && [ -n "$armhf_url" ] && [ -n "$arm64_url" ] && [ -f install ]; then
    pi_apps_ver="$(cat 'install' | grep -m 1 "version${version_number}=" | sed "s/version${version_number}=//" | xargs)"
fi

# install-32 exists
if [ -n "$pi_apps_ver_32" ]  && [ -a "$DIRECTORY/apps/$app_name/install-32" ]; then
    status "The current version in Pi-Apps install-32 is:  $pi_apps_ver_32"
    if [[ "$pi_apps_ver_32" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install-32 version for $app_name is current!"
        if ! validate_url "$armhf_url"; then
            warning "Current $app_name install-32 may be broken, the upstream file $armhf_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Current $app_name install-32 may be broken, the upstream file $armhf_url does NOT exist." >> /tmp/failed_apps
        fi
    else
        #If version is not current do:
        if validate_url "$armhf_url"; then
            status_green "Updating pi-apps $app_name install-32 to: $armhf_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install-32
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" uninstall
            echo "- $app_name-armhf: $pi_apps_ver_32 -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-32 had been skipped, the upstream file $armhf_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Updating $app_name install-32 had been skipped, the upstream file $armhf_url does NOT exist." >> /tmp/failed_apps
        fi
    fi
fi

# install-64 exists
if [ -n "$pi_apps_ver_64" ] && [ -a "$DIRECTORY/apps/$app_name/install-64" ]; then
    status "The current version in Pi-Apps install-64 is:  $pi_apps_ver_64"
    if [[ "$pi_apps_ver_64" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install-64 version for $app_name is current!"
        if ! validate_url "$arm64_url"; then
            warning "Current $app_name install-64 may be broken, the upstream file $arm64_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Current $app_name install-64 may be broken, the upstream file $arm64_url does NOT exist." >> /tmp/failed_apps
        fi
    else
        if validate_url "$arm64_url"; then
            status_green "Updating pi-apps $app_name install-64 to: $arm64_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install-64
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" uninstall
            echo "- $app_name-arm64: $pi_apps_ver_64 -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-64 had been skipped, the upstream file $arm64_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Updating $app_name install-64 had been skipped, the upstream file $arm64_url does NOT exist." >> /tmp/failed_apps
        fi
    fi
fi

# install exists and all_url is used
if [ -n "$pi_apps_ver" ] && [ -n "$all_url" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
        if ! validate_url "$all_url"; then
            warning "Current $app_name install may be broken, the upstream file $all_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Current $app_name install may be broken, the upstream file $all_url does NOT exist." >> /tmp/failed_apps
        fi
    else
        if validate_url "$all_url"; then
            status_green "Updating pi-apps $app_name install to: $all_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" uninstall
            echo "- $app_name-all: $pi_apps_ver -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $all_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Updating $app_name install had been skipped, the upstream file $all_url does NOT exist." >> /tmp/failed_apps
        fi
    fi
fi

# install exists and individual armhf_url and arm64_url are supplied and version_armhf and version_arm64 are used
if [ -n "$pi_apps_ver_32" ] && [ -n "$pi_apps_ver_64" ] && [ -n "$armhf_url" ] && [ -n "$arm64_url" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version_armhf in Pi-Apps install is:  $pi_apps_ver_32"
    if [[ "$pi_apps_ver_32" = "$version_armhf" ]]; then
        #If the version is current do:
        status "Pi-Apps install version_armhf for $app_name is current!"
        if ! validate_url "$armhf_url"; then
            warning "Current $app_name install may be broken, the upstream file $armhf_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Current $app_name install may be broken, the upstream file $armhf_url does NOT exist." >> /tmp/failed_apps
        fi
    else
        if validate_url "$armhf_url"; then
            status_green "Updating pi-apps $app_name install to: $armhf_url"
            sed -i "0,/version_armhf${version_number}=.*/s;;version_armhf${version_number}=${version_armhf};g" install
            sed -i "0,/version_armhf${version_number}=.*/s;;version_armhf${version_number}=${version_armhf};g" uninstall
            echo "- $app_name-armhf: $pi_apps_ver_32 -> ${version_armhf} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $armhf_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Updating $app_name install had been skipped, the upstream file $armhf_url does NOT exist." >> /tmp/failed_apps
        fi
    fi
    status "The current version_arm64 in Pi-Apps install is:  $pi_apps_ver_64"
    if [[ "$pi_apps_ver_64" = "$version_arm64" ]]; then
        #If the version is current do:
        status "Pi-Apps install version_arm64 for $app_name is current!"
        if ! validate_url "$arm64_url"; then
            warning "Current $app_name install may be broken, the upstream file $arm64_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Current $app_name install may be broken, the upstream file $arm64_url does NOT exist." >> /tmp/failed_apps
        fi
    else
        if validate_url "$arm64_url"; then
            status_green "Updating pi-apps $app_name install to: $arm64_url"
            sed -i "0,/version_arm64${version_number}=.*/s;;version_arm64${version_number}=${version_arm64};g" install
            sed -i "0,/version_arm64${version_number}=.*/s;;version_arm64${version_number}=${version_arm64};g" uninstall
            echo "- $app_name-arm64: $pi_apps_ver_64 -> ${version_arm64} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $arm64_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Updating $app_name install had been skipped, the upstream file $arm64_url does NOT exist." >> /tmp/failed_apps
        fi
    fi
fi

# install exists and individual armhf_url and arm64_url are supplied and version is used
if [ -n "$pi_apps_ver" ] && [ -n "$armhf_url" ] && [ -n "$arm64_url" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
        if ! ( validate_url "$armhf_url" && validate_url "$arm64_url" ); then
            warning "Current $app_name install may be broken, the upstream file $armhf_url or $arm64_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Current $app_name install may be broken, the upstream file $armhf_url or $arm64_url does NOT exist." >> /tmp/failed_apps
        fi
    else
        if validate_url "$armhf_url" && validate_url "$arm64_url"; then
            status_green "Updating pi-apps $app_name install to: $armhf_url $arm64_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" uninstall
            echo "- $app_name-all: $pi_apps_ver -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $armhf_url or $arm64_url does NOT exist."
            echo '![badge-warning][badge-warning]'" Updating $app_name install had been skipped, the upstream file $armhf_url or $arm64_url does NOT exist." >> /tmp/failed_apps
        fi
    fi
fi

done
else

warning "webVer variable is missing for $app_name update script, please fix this script, skipping update check."
echo '![badge-issue][badge-issue]'" webVer variable is missing for $app_name update script, please fix this script, skipping update check." >> /tmp/failed_apps

fi

unset webVer
unset version
unset version_armhf
unset version_arm64
unset pi_apps_ver_32
unset pi_apps_ver_64
unset pi_apps_ver
unset armhf_url
unset arm64_url
unset all_url
