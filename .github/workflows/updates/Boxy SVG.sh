#!/bin/bash

webVer=$(wget https://raw.githubusercontent.com/boxy-svg/boxy-svg-snap/master/snap/snapcraft.yaml -qO- | grep source: -m 1 | tr '?-' '\n' | grep '\.zip$')
all_url="https://firebasestorage.googleapis.com/v0/b/boxy-svg.appspot.com/o/linux%2Fapp-${webVer}?alt=media"

# use custom updater due to firebasestorage.googleapis.com not allowing URL verification
# if the URL is not valid, this will updating this app will fail testing the install script in the github actions updater

# make sure webVer variable is supplied by the sourcing script
if [ -n "$webVer" ]; then
  version_number=""
  # echo the versions
  status "The latest online version is:  $webVer"

  if [ -z "$pi_apps_ver" ] && [ -n "$all_url" ] && [ -f install ]; then
    pi_apps_ver="$(cat 'install' | grep -m 1 "version${version_number}=" | sed "s/version${version_number}=//" | xargs)"
  fi

  # install exists and all_url is used
  if [ -n "$pi_apps_ver" ] && [ -n "$all_url" ] && [ -a "$DIRECTORY/apps/$app_name/install" ]; then
    status "The current version in Pi-Apps install is:  $pi_apps_ver"
    if [[ "$pi_apps_ver" = "$webVer" ]]; then
      #If the version is current do:
      status "Pi-Apps install version for $app_name is current!"
    else
      status_green "Updating pi-apps $app_name install to: $all_url"
      sed -i "0,/version${version_number}=.*/s;;version${version_number}=${webVer};g" install
      echo "- $app_name-all: $pi_apps_ver -> ${webVer} " >> /tmp/updated_apps
    fi
  fi

else
  warning "webVer variable is missing for $app_name update script, please fix this script, skipping update check."
  echo "**webVer variable is missing for $app_name update script, please fix this script, skipping update check.**" >> /tmp/failed_apps
fi

unset webVer
unset pi_apps_ver
unset all_url
