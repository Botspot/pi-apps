#!/bin/bash

sudo chown runner:docker /home/runner
# print user info
echo $USER $USERNAME $(id) $(whoami)
sudo bash -c 'echo $USER $USERNAME $(id) $(whoami)'
echo "GITHUB_JOB: $GITHUB_JOB"
echo "app_name: $app_name"

# print date
date

#output functions below
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

# create standard directories
mkdir -p  $HOME/.local/share/applications $HOME/.local/bin
sudo mkdir -p /usr/local/bin /usr/local/share/applications

if [[ "$GITHUB_JOB" == "bionic-64bit" ]]; then
  # fix nvidia jank
  # update sources list for t210
  sudo sed -i "s/<SOC>/t210/" /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
  # add ld conf files
  echo "/usr/lib/aarch64-linux-gnu/tegra-egl" | sudo tee /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf
  echo "/usr/lib/aarch64-linux-gnu/tegra" | sudo tee /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf
fi

# install pi-apps dependencies
sudo apt update
if [[ "$GITHUB_JOB" == "bionic-64bit" ]]; then
  # update certificate chain
  sudo apt install -y ca-certificates
fi
sudo apt install -y yad curl wget aria2 lsb-release software-properties-common apt-utils imagemagick bc librsvg2-bin locales shellcheck git wmctrl xdotool x11-utils rsync



# upgrade cmake to 3.20+ from theofficialgman ppa to fix QEMU only issue https://gitlab.kitware.com/cmake/cmake/-/issues/20568

echo "Adding cmake PPA repository..."
echo "deb [arch=$(dpkg --print-architecture)] https://ppa.launchpadcontent.net/theofficialgman/cmake-bionic/ubuntu bionic main " | sudo tee /etc/apt/sources.list.d/theofficialgman-ubuntu-cmake-bionic-bionic.list || error "Failed to add repository to sources.list!"

# Add cmake ppa keyring
echo "Signing cmake PPA repository..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0ACACB5D1E74E484
if [ $? != 0 ];then
  sudo rm -f /etc/apt/sources.list.d/theofficialgman-ubuntu-cmake-bionic-bionic.list
  error "Failed to sign the cmake PPA!"
fi

# clean out any app status files
rm -rf ./data/status

./manage install "$app_name" || error "Failed to install $app_name on $GITHUB_JOB."
./manage uninstall "$app_name" || error "Failed to uninstall $app_name on $GITHUB_JOB."

status_green "Successfully installed and uninstalled $app_name on $GITHUB_JOB."
