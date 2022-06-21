#!/bin/bash

# to run this script as part of other update scripts, source the directory like below
# source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh


# for apps with an install-32 file, make sure that you supply the following variables before sourcing this script (examples for webcord shown below)
# the ${webVer} variable within the url is important
# it is assumed that your install script will contain a version variable with the version of the app you would like to keep updated automatically

# webVer=$(get_release SpacingBat3/WebCord)
# armhf_url="https://github.com/SpacingBat3/WebCord/releases/download/v${webVer}/webcord_${webVer}_armhf.deb"

# for apps with an install-64 file, make sure that you supply the following variables before sourcing this script (examples for webcord shown below)
# if a variable is already set, no need to duplicate it

# webVer=$(get_release SpacingBat3/WebCord)
# arm64_url="https://github.com/SpacingBat3/WebCord/releases/download/v${webVer}/webcord_${webVer}_arm64.deb"

# for apps with a unified install file, make sure to supply the following variables before sourcing this script

# webVer=$(get_release subhra74/xdm)
# all_url="https://github.com/subhra74/xdm/releases/download/${webVer}/xdm-setup-${webVer}.tar.xz"

# make sure webVer variable is supplied by the sourcing script
if [ -n "$webVer" ]; then
#iterate through all webVer supplied if an array
for (( iter=0; iter<${#webVer[@]}; iter++ )); do
#make array appear as one variable inside for loop
webVer=${webVer[$iter]}
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
    else
        #If version is not current do:
        if validate_url "$armhf_url"; then
            status_green "Updating pi-apps $app_name install-32 to: $armhf_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install-32
            echo "- $app_name-armhf: $pi_apps_ver_32 -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-32 had been skipped, the upstream file $armhf_url does NOT exist."
            echo "**Updating $app_name install-32 had been skipped, the upstream file $armhf_url does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

# install-64 exists
if [ -n "$pi_apps_ver_64" ] && [ -a "$DIRECTORY/apps/$app_name/install-64" ]; then
    status "The current version in Pi-Apps install-64 is:  $pi_apps_ver_64"
    if [[ "$pi_apps_ver_64" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install-64 version for $app_name is current!"
    else
        if validate_url "$arm64_url"; then
            status_green "Updating pi-apps $app_name install-64 to: $arm64_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install-64
            echo "- $app_name-arm64: $pi_apps_ver_64 -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-64 had been skipped, the upstream file $arm64_url does NOT exist."
            echo "**Updating $app_name install-64 had been skipped, the upstream file $arm64_url does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

# install exists and all_url is used
if [ -n "$pi_apps_ver" ] && [ -n "$all_url" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
    else
        if validate_url "$all_url"; then
            status_green "Updating pi-apps $app_name install to: $all_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install
            echo "- $app_name-all: $pi_apps_ver -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $all_url does NOT exist."
            echo "**Updating $app_name install had been skipped, the upstream file $all_url does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

# install exists and individual armhf_url and arm64_url are supplied
if [ -n "$pi_apps_ver" ] && [ -n "$armhf_url" ] && [ -n "$arm64_url" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
    else
        if validate_url "$armhf_url" && validate_url "$arm64_url"; then
            status_green "Updating pi-apps $app_name install to: $armhf_url $arm64_url"
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install
            echo "- $app_name-all: $pi_apps_ver -> ${webVer} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $armhf_url or $arm64_url does NOT exist."
            echo "**Updating $app_name install had been skipped, the upstream file $armhf_url or $arm64_url does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

done
else

warning "webVer variable is missing for $app_name update script, please fix this script, skipping update check."
echo "**webVer variable is missing for $app_name update script, please fix this script, skipping update check.**" >> /tmp/failed_apps

fi

unset webVer
unset pi_apps_ver_32
unset pi_apps_ver_64
unset pi_apps_ver
unset armhf_url
unset arm64_url
unset all_url
