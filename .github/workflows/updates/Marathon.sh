#!/bin/bash

webVer=$(get_release Aleph-One-Marathon/alephone | tr -d "release-")

all_url[0]="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${webVer}/AlephOne-${webVer}.tar.bz2"
all_url[1]="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${webVer}/Marathon-${webVer}-Data.zip"
all_url[2]="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${webVer}/Marathon2-${webVer}-Data.zip"
all_url[3]="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${webVer}/MarathonInfinity-${webVer}-Data.zip"

# custom updater for checking multiple URLs and one version

# echo the versions
status "The latest online version is:  $webVer"

version_number=""
unset pi_apps_ver

if [ -f install ]; then
    pi_apps_ver="$(cat 'install' | grep -m 1 "version${version_number}=" | sed "s/version${version_number}=//" | xargs)"
else
    warning "Could not find $app_name install file"
    echo "**Could not find $app_name install file**" >> /tmp/failed_apps
fi

if [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
        #If the version is current do:
        status "Pi-Apps install version for $app_name is current!"
    else
        status=""
        for (( iter=0; iter<${#all_url[@]}; iter++ )); do
            #make array appear as one variable inside for loop
            webVer=${webVer}
            pi_apps_ver=${pi_apps_ver}
            all_url=${all_url[$iter]}
            if validate_url "$all_url"; then
                status=1
                status_green "Updating pi-apps $app_name install to: $all_url"
            else
                status=0
                warning "Updating $app_name install had been skipped, the upstream file $all_url does NOT exist."
                echo "**Updating $app_name install had been skipped, the upstream file $all_url does NOT exist.**" >> /tmp/failed_apps
                break
            fi
        done
        if [[ $status == 1 ]]; then
            sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install
            echo "- $app_name-all: $pi_apps_ver -> ${webVer} " >> /tmp/updated_apps
        fi
    fi
fi

unset webVer
unset pi_apps_ver_32
unset pi_apps_ver_64
unset pi_apps_ver
unset armhf_url
unset arm64_url
unset all_url
