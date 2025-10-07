#!/bin/bash

sudo chown runner:docker /home/runner
# print user info
echo $USER $USERNAME $(id) $(whoami)
sudo bash -c 'echo $USER $USERNAME $(id) $(whoami)'
echo "GITHUB_JOB: $GITHUB_JOB"

# set DIRECTORY variable
DIRECTORY="$(pwd)"

# print date
date

#necessary functions
error() { #red text and exit 1
  echo -e "\e[91m$1\e[0m" 1>&2
  exit 1
}

warning() { #yellow text
  echo -e "\e[93m\e[5m◢◣\e[25m WARNING: $1\e[0m" 1>&2
}

status() { #cyan text to indicate what is happening
  
  #detect if a flag was passed, and if so, pass it on to the echo command
  if [[ "$1" == '-'* ]] && [ ! -z "$2" ];then
    echo -e $1 "\e[96m$2\e[0m" 1>&2
  else
    echo -e "\e[96m$1\e[0m" 1>&2
  fi
}

status_green() { #announce the success of a major action
  echo -e "\e[92m$1\e[0m" 1>&2
}

import_zip() { #given a zipfile, extract it to apps directory and return the name of the app
  local import="$1"
  [ -z "$import" ] || [ ! -f "$import" ] && error "import_zip(): invalid input: '$import'"
  
  #create a temporary directory to extract to
  local tmpdir="$(mktemp -d)" || error "Failed to create a temporaty folder for some reason.\nErrors:\n$tmpdir"
  #be sure to delete the temporary folder on exit
  trap "rm -rf '$tmpdir'" EXIT
  
  #unzip to the temporary directory
  local errors="$(unzip "$import" -d "$tmpdir" 2>&1)" || error "Failed to extract '$import' to '$tmpdir'.\nErrors: $errors"
  
  #some zip files have an inner directory that app-files are situated in; others don't.
  if [ "$(find "$tmpdir" -maxdepth 1 -type d | tail +2 | wc -l)" == 1 ] && [ "$(find "$tmpdir" -maxdepth 1 -type f | tail +2 | wc -l)" == 0 ];then
    #if the temporary directory contains exactly one folder and zero loose files
    echo "$(basename "$import") contains exactly one folder and zero loose files" 1>&2
    
    local app_name="$(basename "$(find "$tmpdir" -maxdepth 1 -type d | tail +2)")"
    #return the name of the app
    echo "$app_name"
    [ -z "$app_name" ] && error "Failed to determine a name for the app, given this filename: '$import'"
    #remove the app from pi-apps first
    rm -rf "${DIRECTORY}/apps/${app_name}"
    
    #then move the folder straight to the pi-apps folder
    mv -f "$(find "$tmpdir" -maxdepth 1 -type d | tail +2)" "${DIRECTORY}/apps"
    
  else #if extracted archive did not contain exactly one folder and zero loose files
    echo "$(basename "$import") did not contain exactly one folder and zero loose files" 1>&2
    
    #create a folder in the apps directory first
    newfolder="${DIRECTORY}/apps/$(basename "$import" | awk -F'.' '{print $1}')"
    [ "$newfolder" == "${DIRECTORY}/apps/" ] && error "Failed to determine a name for the app, given this filename: '$import'"
    rm -rf "$newfolder"
    mkdir -p "$newfolder"
    
    #return the name of the app
    basename "$newfolder"
    
    #then move the extracted files over, into the app-folder
    mv -f "$tmpdir"/* "$newfolder"
  fi
}

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]]; then
  # fix nvidia jank
  # update sources list for t210
  sudo sed -i "s/<SOC>/t210/" /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
fi

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]] || [[ "$GITHUB_JOB" == "l4t-jammy-64bit" ]] || [[ "$GITHUB_JOB" == "l4t-noble-64bit" ]]; then
  # add ld conf files (normally handled by service on first launch)
  echo "/usr/lib/aarch64-linux-gnu/tegra-egl" | sudo tee /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf
  echo "/usr/lib/aarch64-linux-gnu/tegra" | sudo tee /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf
  # note that we are in a chroot to skip bootfile configuration
  sudo mkdir -p /opt/switchroot
  sudo touch /opt/switchroot/image_prep
fi

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]]; then
  # skip joycond postinst
  # fixed in newer releases
  sudo rm /var/lib/dpkg/info/joycond.postinst -f
  sudo dpkg --configure joycond
fi

if [[ "$GITHUB_JOB" == "l4t-focal-64bit" ]]; then
  # fix nvidia jank
  # update sources list for t194
  sudo sed -i "s/<SOC>/t194/" /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
fi

if [[ "$GITHUB_JOB" == "jammy-64bit" ]] || [[ "$GITHUB_JOB" == "lunar-64bit" ]]; then
  # remove packages that won't work in the chroot
  sudo apt remove -y linux-image-*-raspi linux-modules-*-raspi linux-image-raspi linux-raspi linux-headers-raspi
fi

if [[ "$GITHUB_JOB" == "noble-64bit" ]]; then
  # workaround upstream bug in default image https://bugs.launchpad.net/ubuntu-cdimage/+bug/2065213
  sudo wget -O /etc/apt/sources.list.d/ubuntu.sources https://raw.githubusercontent.com/theofficialgman/l4t-image-buildscripts/master/files/overwrite-files/noble/gnome/ubuntu.sources
fi

# install pi-apps dependencies
sudo apt update
if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]]; then
  # update certificate chain
  sudo apt install -y ca-certificates
fi
sudo apt install -y software-properties-common || true
sudo apt install -y yad curl wget aria2 lsb-release apt-utils imagemagick bc librsvg2-bin locales shellcheck git wmctrl xdotool x11-utils rsync

#determine what type of input we received
if [ -z "$name" ]; then
  error "No App Name, PR #, or zip URL input passed to script. Exiting now."
fi
import="$(echo "$name" | tr ';' '\n')"

if ls apps | grep -q "$import" ;then
  #pi-apps app name as input
  imported_apps="$import"

elif [[ "$import" == *'://'*'.zip' ]];then

  #given a download link to a zip file

  #create a temporary directory to extract to
  tmpdir="$(mktemp -d)" || error "Failed to create a temporaty folder for some reason.\nErrors:\n$tmpdir"
  #be sure to delete the temporary folder on exit
  trap "rm -rf '$tmpdir'" EXIT
  
  filename="$tmpdir/$(basename "$import")"
  
  #download the zip file
  wget "$import" -O "$filename" || error "Failed to download '$import' to '$filename'"
  
  #use the import_zip function to import the app, keeping a record of the app-name
  imported_apps="$(import_zip "$filename")"
  
elif [[ "$import" =~ ^[0-9]+$ ]] || [[ "$import" == *'://'*'/pull/'*[0-9] ]];then
  #given a pull request for an app
  
  #if given a PR number, assume it's a PR on the pi-apps repo
  if [[ "$import" =~ ^[0-9]+$ ]];then
    PR="https://github.com/Botspot/pi-apps/pull/${import}"
  else
    #if given a url to a PR
    PR="$import"
  fi
  
  #repobranch='https://github.com/cycool29/pi-apps/tree/msteams'
  repobranch="$(wget -qO- "$PR" | grep -x 'from' --after 2 | tr '<> ' '\n' | grep 'title="' | sed 's/title="//g' | sed 's/"$//g' | head -n1)"
  
  if [ -z "$repobranch" ];then
    error "No PR was found that mentions a branch."
  else
    echo "repobranch: $repobranch"
  fi
  
  #Take a combined repo/branch url and separate it.
  #example value of repobranch: https://github.com/cycool29/pi-apps/tree/msteams
  
  repo="$(echo "$repobranch" | awk -F: '{print $1}')" #value: cycool29/pi-apps
  branch="$(basename "$repobranch" | awk -F: '{print $2}')" #value: msteams
  username="$(dirname "$repo" | sed 's+^/++g')" #value: cycool29
  
  #make a temporary directory and enter it
  cd "$(mktemp -d)" || error "Failed to create and enter a temporary directory."
  #if script is killed prematurely, be sure to delete the temporary folder
  trap "rm -rf '$(pwd)'" EXIT
  
  echo -e "\nrepo: $repo\nbranch: $branch\nusername: $username\ntmpdir: $(pwd)\n"
  
  echo -n "Downloading repository... "
  errors="$(git clone "https://github.com/${repo}" -b $branch -q pi-apps 2>&1)" || error "Failed to clone repository: $repo\nErrors:\n$errors"
  echo "Done"
  
  echo -n "Syncing fork with upstream repo... "
  cd $(pwd)/pi-apps
  git config user.email "user@example.com" #set email in this repo so that it can pull
  git config user.name "user" #set username in this repo so that it can pull
  errors="$(git pull https://github.com/Botspot/pi-apps --rebase -q 2>&1)" || error "Failed to sync upstream repo. \nErrors:\n$errors"
  
  cd .. #back to tmpdir
  echo "Done"
  
  echo -n "Getting pi-apps repo for comparison... "
  errors="$(git clone "https://github.com/Botspot/pi-apps" pi-apps-master -q 2>&1)" || error "Failed to clone Botspot pi-apps repository.\nErrors:\n$errors"
  echo "Done"
  
  #get list of apps that are unique to this pi-apps folder. (not on main repo)
  applist="$("$(pwd)/pi-apps/api" list_apps local_only)"
  
  #get apps that don't match the ones in main branch - find only new apps
  imported_apps="$(diff -rq "$(pwd)/pi-apps/apps" "$(pwd)/pi-apps-master/apps" | grep "Only in $(pwd)/pi-apps/apps:"  | sed 's+.*/pi-apps-master.++g' | sed 's+.*apps/++g' | sed 's+.*apps: ++g'  | sed 's+/.*++g' | sort | uniq | grep .)"

  IFS=$'\n'
  for app in $applist
  do
    echo -en "Scanning apps... $app\033[0K\r" 1>&2

    if [ -d "$(pwd)/pi-apps/apps/${app}" ] && [ -d "$(pwd)/pi-apps-master/apps/${app}" ] && ! diff -r "$(pwd)/pi-apps/apps/${app}" "$(pwd)/pi-apps-master/apps/${app}" -q >/dev/null 2>&1; then
      #if app hashes don't match, add to imported list
      #find only changed apps
      if [ -z "$imported_apps" ]; then
        # imported apps is blank, do not add newline
        imported_apps="${app}"
      else
        # imported apps is not blank, add newline
        imported_apps="${imported_apps}
${app}"
      fi
    fi
  done
  
  IFS=$'\n'
  for app in $imported_apps ;do
    #remove directory first and replace with copied version from PR
    #this prevents orphaned files when moving from install-32/install-64 to install
    rm -rf "${DIRECTORY}/apps/$app"
    cp -af "$(pwd)/pi-apps/apps/$app" "${DIRECTORY}/apps"
    echo "Copied '$(pwd)/pi-apps/apps/${app}' to ${DIRECTORY}/apps"
  done
  
else
  #unrecognized input
  error "Unrecognized input '$import'"
fi

cd "$DIRECTORY"

status "Testing app(s): $imported_apps"

# create standard directories
mkdir -p  $HOME/.local/share/applications $HOME/.local/bin $HOME/Desktop
sudo mkdir -p /usr/local/bin /usr/local/share/applications

# clean out any app status files
rm -rf ./data/status

# create pi-apps install directories
mkdir -p "${DIRECTORY}/data/status" "${DIRECTORY}/data/update-status" \
  "${DIRECTORY}/data/preload" "${DIRECTORY}/data/settings" \
  "${DIRECTORY}/data/status" "${DIRECTORY}/data/update-status" \
  "${DIRECTORY}/data/categories"

#Force disable analytics. This needs to be done before before running the runonce-entries to avoid sending clicks for already installed package apps
echo "No" > "${DIRECTORY}/data/settings/Enable analytics"

# runonce-entries is run in the build tester, runonce requires that all api functions be available to subprocess (like is done in the gui script)
#for the will_reinstall() and list_intersect() functions
set -a #make all functions in the api available to subprocesses
source "${DIRECTORY}/api" || error "failed to source ${DIRECTORY}/api"
#Run runonce entries
"${DIRECTORY}/etc/runonce-entries"
set +a #stop exporting functions

# upgrade cmake to 3.20+ from theofficialgman ppa to fix QEMU only issue https://gitlab.kitware.com/cmake/cmake/-/issues/20568
package_is_new_enough cmake 3.20 || debian_ppa_installer "theofficialgman/cmake-bionic" "bionic" "0ACACB5D1E74E484" || exit 1

IFS=$'\n'
for app in $imported_apps ;do
  cd "$DIRECTORY"
  ./manage install "$app" || error "Failed to install $app on $GITHUB_JOB."
  status_green "Successfully installed $app on $GITHUB_JOB."
done
IFS=$'\n'
for app in $imported_apps ;do
  cd "$DIRECTORY"
  ./manage uninstall "$app" || error "Failed to uninstall $app on $GITHUB_JOB."
  status_green "Successfully uninstalled $app on $GITHUB_JOB."
done
