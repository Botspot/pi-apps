#!/bin/bash

# remove deprecated repofilename
sudo rm -f /etc/apt/sources.list.d/firefox-ubuntu.list
# remove /etc/apt/preferences.d/99bionic-updates which was added when bionic default repositories were added
sudo rm -f /etc/apt/preferences.d/99bionic-updates
# get local dpkg architecture for error logs
arch="$(dpkg --print-architecture)"
case "$__os_id" in
Ubuntu)
  # starting on 22.04 the apt package for firefox is a snap so we need to add the ppa
  # 18.04 firefox is no longer being updated so we also want to use the ppa on it
  if printf '%s\n' "22.04" "$__os_release" | sort -CV || [[ "$__os_release" == "18.04" ]]; then
    ubuntu_ppa_installer "mozillateam/ppa"
    # also disable firefox snap apt package from Ubuntu
    echo 'Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1000

Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1' | sudo tee /etc/apt/preferences.d/firefox >/dev/null
  
    # allow unattented upgrades to upgrade from this ppa if unattented upgrades is enabled
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null
    install_packages firefox || error "User error (reporting allowed): Firefox is not available from Mozilla Team PPA for $arch Ubuntu ${__os_codename^}. Please contact Mozilla Team via email for any issues ubuntu-mozillateam-bugs@lists.ubuntu.com"
  else
    install_packages firefox || exit 1
  fi
  # install_packages will not switch an already installed 1:1snap* package to a XXX firefox package since this would constitute a downgrade
  # the pin priorities added above will prevent Ubuntu repository firefox packages from even showing or installing in the future but we still need to do the initial downgrade from 1:1snap* to the ppa version of firefox
  apt_lock_wait
  sudo apt --only-upgrade --allow-downgrades install firefox -y | less_apt
  true
  ;;
*)
  # Add repository source to apt sources.list
  # also allow unattented upgrades to upgrade from this ppa if unattented upgrades is enabled
  case $__os_codename in
  bookworm)
    if [ -f /etc/rpi-issue ]; then
      status "PiOS Bookworm supports the latest HW Accelerated Firefox out of the box. Skipping adding Mozilla PPA"
      install_packages firefox || exit 1
    else
      # remove old ppa if present
      sudo rm -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-bionic.list
      debian_ppa_installer "mozillateam/ppa" "jammy" "0AB215679C571D1C8325275B9BDB3D89CE49EC21" || exit 1
      echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null
      install_packages firefox || error "User error (reporting allowed): Firefox is not available from Mozilla Team PPA for $arch Ubuntu Jammy (used for Debian Bookworm). Please contact Mozilla Team via email for any issues ubuntu-mozillateam-bugs@lists.ubuntu.com"
    fi
    ;;
  bullseye)
    # remove old ppa if present
    sudo rm -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-bionic.list
    debian_ppa_installer "mozillateam/ppa" "focal" "0AB215679C571D1C8325275B9BDB3D89CE49EC21" || exit 1
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:focal";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null    
    install_packages firefox || error "User error (reporting allowed): Firefox is not available from Mozilla Team PPA for $arch Ubuntu Focal (used for Debian Bullseye). Please contact Mozilla Team via email for any issues ubuntu-mozillateam-bugs@lists.ubuntu.com"
    ;;
  *)
    debian_ppa_installer "mozillateam/ppa" "bionic" "0AB215679C571D1C8325275B9BDB3D89CE49EC21" || exit 1
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:bionic";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null
    install_packages firefox || error "User error (reporting allowed): Firefox is not available from Mozilla Team PPA for $arch Ubuntu Bionic. Please contact Mozilla Team via email for any issues ubuntu-mozillateam-bugs@lists.ubuntu.com"
    ;;
  esac
  sudo apt --only-upgrade install firefox -y | less_apt
  true
  ;;
esac
