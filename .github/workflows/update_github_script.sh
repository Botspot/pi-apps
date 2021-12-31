#!/bin/bash

# to run this script as part of other update scripts, source the directory like below
# source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh


# for apps with an install-32 file, make sure that you supply the following variables before sourcing this script (examples for webcord shown below)
# the ${webVer} variable within the url is important

# webVer=$(get_release SpacingBat3/WebCord)
# armhf_url="https://github.com/SpacingBat3/WebCord/releases/download/v${webVer}/webcord_${webVer}_armhf.deb"
# pi_apps_ver_32="$(cat 'install-32' | grep 'version=' | sed 's/version=//')"


# for apps with an install-64 file, make sure that you supply the following variables before sourcing this script (examples for webcord shown below)
# if a variable is already set, no need to duplicate it

# webVer=$(get_release SpacingBat3/WebCord)
# arm64_url="https://github.com/SpacingBat3/WebCord/releases/download/v${webVer}/webcord_${webVer}_arm64.deb"
# pi_apps_ver_64="$(cat 'install-64' | grep 'version=' | sed 's/version=//')"


# for apps with a unified install file, make sure to supply the following variables before sourcing this script

# webVer=$(get_release subhra74/xdm)
# all_url="https://github.com/subhra74/xdm/releases/download/${webVer}/xdm-setup-${webVer}.tar.xz"
# pi_apps_ver="$(cat 'install' | grep 'version=' | sed 's/version=//')"

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

# install-32 exists
if [ -n "$pi_apps_ver_32" ]  && [ -a "$DIRECTORY/apps/$app_name/install-32" ]; then
    status "The current version in Pi-Apps install-32 is:  $pi_apps_ver_32"
    if [[ "$pi_apps_ver_32" = "$webVer" ]]; then
        #If the version is current do:
        status_green "Pi-Apps install-32 version for $app_name is current!"
    else
        #If version is not current do:
        if validate_url "$armhf_url"; then
            status_green "Updating pi-apps $app_name install-32 to: $armhf_url"
            sed -i "s/version${version_number}=.*/version${version_number}=${webVer}/g" install-32
            echo "$app_name-armhf " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-32 had been skipped, the upstream file $armhf_url does NOT exist."
        fi
    fi
fi

# install-64 exists
if [ -n "$pi_apps_ver_64" ] && [ -a "$DIRECTORY/apps/$app_name/install-64" ]; then
    status "The current version in Pi-Apps install-64 is:  $pi_apps_ver_64"
    if [[ "$pi_apps_ver_64" = "$webVer" ]]; then
        #If the version is current do:
        status_green "Pi-Apps install-64 version for $app_name is current!"
    else
        if validate_url "$arm64_url"; then
            status_green "Updating pi-apps $app_name install-64 to: $arm64_url"
            sed -i "s/version${version_number}=.*/version${version_number}=${webVer}/g" install-64
            echo "$app_name-arm64 " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-64 had been skipped, the upstream file $arm64_url does NOT exist."
        fi
    fi
fi

# install exists
if [ -n "$pi_apps_ver" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
        #If the version is current do:
        status_green "Pi-Apps install version for $app_name is current!"
    else
        if validate_url "$all_url"; then
            status_green "Updating pi-apps $app_name install to: $all_url"
            sed -i "s/version${version_number}=.*/version${version_number}=${webVer}/g" install
            echo "$app_name-all " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file $all_url does NOT exist."
        fi
    fi
fi

done
else

warning "webVer variable is missing for $appname update script, please fix this script, skipping update check"

fi