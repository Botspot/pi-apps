#!/bin/bash

# to run this script as part of other update scripts, source the directory like below
# source $GITHUB_WORKSPACE/.github/workflows/update_debian_repo_script.sh

# you must have already set corresponding values for armhf_webPackages, arm64_webPackages, or all_webPackages
# The corresponding appname in pi-apps will have its corresponding filepath= variable update
# the filepath variable will contain the full filepath of the debian package with the version included

# make sure required variable(s) is(are) supplied by the sourcing script
if [ -n "$armhf_webPackages" ] || [ -n "$arm64_webPackages" ] || [ -n "$all_webPackages" ]; then
#iterate through all variables supplied if an array
# get longest arrary of passed variables
num=$(echo -e "${#armhf_webPackages[@]}\n${#arm64_webPackages[@]}\n${#all_webPackages[@]}" | sort -n -r | head -1)

for (( iter=0; iter<$num; iter++ )); do
#make array appear as one variable inside for loop
armhf_webPackages=${armhf_webPackages[$iter]}
arm64_webPackages=${arm64_webPackages[$iter]}
all_webPackages=${all_webPackages[$iter]}
armhf_packagename=${armhf_packagename[$iter]}
arm64_packagename=${arm64_packagename[$iter]}
all_packagename=${all_packagename[$iter]}
if [[ $iter == "0" ]]; then
    version_number=""
else
    version_number=$((iter + 1))
fi

#set pi_apps_filepath variables
if [ -n "$armhf_webPackages" ] && [ -f install-32 ]; then
    pi_apps_filepath_32="$(cat 'install-32' | grep -m 1 "filepath${version_number}=" | sed "s/filepath${version_number}=//" | xargs)"
fi

if [ -n "$arm64_webPackages" ] && [ -f install-64 ]; then
    pi_apps_filepath_64="$(cat 'install-64' | grep -m 1 "filepath${version_number}=" | sed "s/filepath${version_number}=//" | xargs)"
fi

if [ -n "$all_webPackages" ] && [ -f install ]; then
    pi_apps_filepath="$(cat 'install' | grep -m 1 "filepath${version_number}=" | sed "s/filepath${version_number}=//" | xargs)"
fi

# check for armhf and arm64 URL with a single install script using the same version
if [ -z "$pi_apps_filepath_32" ] && [ -z "$pi_apps_filepath_64" ] && [ -n "$armhf_webPackages" ] && [ -n "$arm64_webPackages" ] && [ -f install ]; then
    pi_apps_filepath_32="$(cat 'install' | grep -m 1 "filepath_32${version_number}=" | sed "s/filepath_32${version_number}=//" | xargs)"
    pi_apps_filepath_64="$(cat 'install' | grep -m 1 "filepath_64${version_number}=" | sed "s/filepath_64${version_number}=//" | xargs)"
fi

# install-32 exists
if [ -n "$pi_apps_filepath_32" ]  && [ -a "$DIRECTORY/apps/$app_name/install-32" ]; then
    status "The current version in Pi-Apps install-32 is:  $pi_apps_filepath_32"
    armhf_webVer="$(wget -qO- "$armhf_webPackages" | awk "/Package: $armhf_packagename\n/" RS= | grep "Version:" | awk '{print $2}' | sort -V | tail -n1)"
    armhf_package_path="$(wget -qO- "$armhf_webPackages" | awk "/Package: $armhf_packagename\n/" RS= | sed -n -e "/Version: ${armhf_webVer}/,/Filename:/ p" | grep "Filename:" | awk '{print $2}')"
    repo_url="$(echo "$armhf_webPackages" | sed 's/dists.*//')"
    if [[ "$pi_apps_filepath_32" = "${repo_url}${armhf_package_path}" ]]; then
        #If the version is current do:
        status "Pi-Apps install-32 version for $app_name is current!"
    else
        #If version is not current do:
        if validate_url "${repo_url}${armhf_package_path}"; then
            status_green "Updating pi-apps $app_name install-32 to: ${repo_url}${armhf_package_path}"
            sed -i "0,/filepath${version_number}=.*/s;;filepath${version_number}=\"${repo_url}${armhf_package_path}\";g" install-32
            echo "- $app_name-armhf: $pi_apps_filepath_32 -> ${repo_url}${armhf_package_path} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-32 had been skipped, the upstream file ${repo_url}${armhf_package_path} does NOT exist."
            echo "**Updating $app_name install-32 had been skipped, the upstream file ${repo_url}${armhf_package_path} does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

# install-64 exists
if [ -n "$pi_apps_filepath_64" ]  && [ -a "$DIRECTORY/apps/$app_name/install-64" ]; then
    status "The current version in Pi-Apps install-64 is:  $pi_apps_filepath_64"
    arm64_webVer="$(wget -qO- "$arm64_webPackages" | awk "/Package: $arm64_packagename\n/" RS= | grep "Version:" | awk '{print $2}' | sort -V | tail -n1)"
    arm64_package_path="$(wget -qO- "$arm64_webPackages" | awk "/Package: $arm64_packagename\n/" RS= | sed -n -e "/Version: ${arm64_webVer}/,/Filename:/ p" | grep "Filename:" | awk '{print $2}')"
    repo_url="$(echo "$arm64_webPackages" | sed 's/dists.*//')"
    if [[ "$pi_apps_filepath_64" = "${repo_url}${arm64_package_path}" ]]; then
        #If the version is current do:
        status "Pi-Apps install-64 version for $app_name is current!"
    else
        #If version is not current do:
        if validate_url "${repo_url}${arm64_package_path}"; then
            status_green "Updating pi-apps $app_name install-64 to: ${repo_url}${arm64_package_path}"
            sed -i "0,/filepath${version_number}=.*/s;;filepath${version_number}=\"${repo_url}${arm64_package_path}\";g" install-64
            echo "- $app_name-arm64: $pi_apps_filepath_64 -> ${repo_url}${arm64_package_path} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install-64 had been skipped, the upstream file ${repo_url}${arm64_package_path} does NOT exist."
            echo "**Updating $app_name install-64 had been skipped, the upstream file ${repo_url}${arm64_package_path} does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

# install exists and all_webPackages is used
if [ -n "$pi_apps_filepath" ]  && [ -n "$all_webPackages" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_filepath"
    all_webVer="$(wget -qO- "$all_webPackages" | awk "/Package: $all_packagename\n/" RS= | grep "Version:" | awk '{print $2}' | sort -V | tail -n1)"
    all_package_path="$(wget -qO- "$all_webPackages" | awk "/Package: $all_packagename\n/" RS= | sed -n -e "/Version: ${all_webVer}/,/Filename:/ p" | grep "Filename:" | awk '{print $2}')"
    repo_url="$(echo "$all_webPackages" | sed 's/dists.*//')"
    if [[ "$pi_apps_filepath" = "${repo_url}${all_package_path}" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
    else
        #If version is not current do:
        if validate_url "${repo_url}${all_package_path}"; then
            status_green "Updating pi-apps $app_name install to: ${repo_url}${all_package_path}"
            sed -i "0,/filepath${version_number}=.*/s;;filepath${version_number}=\"${repo_url}${all_package_path}\";g" install
            echo "- $app_name-all: $pi_apps_filepath -> ${repo_url}${all_package_path} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file ${repo_url}${all_package_path} does NOT exist."
            echo "**Updating $app_name install had been skipped, the upstream file ${repo_url}${all_package_path} does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

# install exists and individual armhf_webPackages and arm64_webPackages are supplied
if [ -n "$pi_apps_filepath_32" ] && [ -n "$pi_apps_filepath_64" ] && [ -n "$armhf_webPackages" ] && [ -n "$arm64_webPackages" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_filepath_32 $pi_apps_filepath_64"
    armhf_webVer="$(wget -qO- "$armhf_webPackages" | awk "/Package: $armhf_packagename\n/" RS= | grep "Version:" | awk '{print $2}' | sort -V | tail -n1)"
    armhf_package_path="$(wget -qO- "$armhf_webPackages" | awk "/Package: $armhf_packagename\n/" RS= | sed -n -e "/Version: ${armhf_webVer}/,/Filename:/ p" | grep "Filename:" | awk '{print $2}')"
    arm64_webVer="$(wget -qO- "$arm64_webPackages" | awk "/Package: $arm64_packagename\n/" RS= | grep "Version:" | awk '{print $2}' | sort -V | tail -n1)"
    arm64_package_path="$(wget -qO- "$arm64_webPackages" | awk "/Package: $arm64_packagename\n/" RS= | sed -n -e "/Version: ${arm64_webVer}/,/Filename:/ p" | grep "Filename:" | awk '{print $2}')"
    repo_url_armhf="$(echo "$armhf_webPackages" | sed 's/dists.*//')"
    repo_url_arm64="$(echo "$arm64_webPackages" | sed 's/dists.*//')"
    if [[ "$pi_apps_filepath_64" = "${repo_url_arm64}${arm64_package_path}" ]] && [[ "$pi_apps_filepath_32" = "${repo_url_armhf}${armhf_package_path}" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
    else
        if validate_url "${repo_url_armhf}${armhf_package_path}" && validate_url "${repo_url_arm64}${arm64_package_path}"; then
            status_green "Updating pi-apps $app_name install to: ${repo_url_armhf}${armhf_package_path} ${repo_url_arm64}${arm64_package_path}"
            sed -i "0,/filepath_32${version_number}=.*/s;;filepath_32${version_number}=\"${repo_url_armhf}${armhf_package_path}\";g" install
            sed -i "0,/filepath_64${version_number}=.*/s;;filepath_64${version_number}=\"${repo_url_arm64}${arm64_package_path}\";g" install
            echo "- $app_name-all: $pi_apps_filepath_32 -> ${repo_url_armhf}${armhf_package_path} " >> /tmp/updated_apps
            echo "- $app_name-all: $pi_apps_filepath_64 -> ${repo_url_arm64}${arm64_package_path} " >> /tmp/updated_apps
        else
            warning "Updating $app_name install had been skipped, the upstream file ${repo_url_armhf}${armhf_package_path} or  ${repo_url_arm64}${arm64_package_path} does NOT exist."
            echo "**Updating $app_name install had been skipped, the upstream file ${repo_url_armhf}${armhf_package_path} or  ${repo_url_arm64}${arm64_package_path} does NOT exist.**" >> /tmp/failed_apps
        fi
    fi
fi

done
else

warning "armhf_webPackages, arm64_webPackages, or all_webPackages variable is missing for $app_name update script, please fix this script, skipping update check."
echo "**armhf_webPackages, arm64_webPackages, or all_webPackages variable is missing for $app_name update script, please fix this script, skipping update check.**" >> /tmp/failed_apps

fi

unset armhf_webPackages
unset arm64_webPackages
unset all_webPackages
unset armhf_packagename
unset arm64_packagename
unset all_packagename
unset pi_apps_filepath_32
unset pi_apps_filepath_64
unset pi_apps_filepath