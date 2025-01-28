#!/bin/bash

version=9.22

# https://github.com/raspberrypi/bookworm-feedback/issues/107
PAGE_SIZE="$(getconf PAGE_SIZE)"
if [[ "$PAGE_SIZE" == "16384" ]]; then
  #switch to 4K pagesize kernel
  if [ -f /boot/config.txt ] || [ -f /boot/firmware/config.txt ]; then
    if [ -f /boot/firmware/config.txt ]; then
      boot_config="/boot/firmware/config.txt"
    elif [ -f /boot/config.txt ]; then
      boot_config="/boot/config.txt"
    fi
    text="Raspberry Pi 5 PiOS images ship by default with a 16K PageSize Linux Kernel.
This kernel causes incompatibilities with some software including Wine https://github.com/raspberrypi/bookworm-feedback/issues/107

Would you like to automatically switch to a 4K PageSize Linux Kernel?"
    userinput_func "$text" "No, keep 16K PageSize Kernel and Exit" "Yes, switch to 4K PageSize Kernel"
    if [ "$output" == "No, keep 16K PageSize Kernel and Exit" ]; then
      error "User error: Your current running kernel is built with 16K PageSize and is incompatible with Wine (x64) with Box64. You must switch to a 4K PageSize kernel (and chose to not do so automatically) before installing Wine (x64)."
    fi
    echo "" | sudo tee --append $boot_config >/dev/null
    echo "[pi5]" | sudo tee --append $boot_config >/dev/null
    echo "kernel=kernel8.img" | sudo tee --append $boot_config >/dev/null
    echo -e "The 4K PageSize Kernel has been enabled by adding 'kernel=kernel8.img' to $boot_config\nPlease reboot now and install the Wine (x64) app again."
    sleep infinity
  else
    error "User error (reporting allowed): Your current running kernel is built with 16K PageSize and is incompatible with Wine (x64) with Box64. Changing kernels automatically cannot be done since no /boot/config.txt or /boot/firmware/config.txt file was found."
  fi
fi

# Hangover conflicts with Wine
"${DIRECTORY}/manage" uninstall "Wine (x64)"
if package_installed fonts-wine ;then
  sudo apt purge fonts-wine -y || exit 1
fi
if package_installed libwine ;then
  sudo apt purge libwine -y || exit 1
fi

if [ "$__os_codename" == "bullseye" ]; then
  ho_distro="debian11"
elif [ "$__os_codename" == "bookworm" ]; then
  ho_distro="debian12"
elif [ "$__os_codename" == "focal" ]; then
  ho_distro="ubuntu2004"
elif [ "$__os_codename" == "jammy" ]; then
  ho_distro="ubuntu2204"
elif [ "$__os_codename" == "noble" ]; then
  ho_distro="ubuntu2404"
else
  error "User error: You are not using a supported Pi-Apps distribution."
fi

cd /tmp || error "Could not move to /tmp folder"
wget https://github.com/AndreRH/hangover/releases/download/hangover-${version}/hangover_${version}_${ho_distro}_${__os_codename}_arm64.tar || error "Failed to download Hangover!"
tar -xf hangover_${version}_${ho_distro}_${__os_codename}_arm64.tar || error "Failed to extract Hangover!"
rm -f hangover_${version}_${ho_distro}_${__os_codename}_arm64.tar
install_packages /tmp/hangover-libarm64ecfex_${version}_arm64.deb /tmp/hangover-libqemu_${version}~${__os_codename}_arm64.deb /tmp/hangover-libwow64fex_${version}_arm64.deb /tmp/hangover-wine_${version}~${__os_codename}_arm64.deb || exit 1
rm -f ./hangover-libarm64ecfex_${version}_arm64.deb ./hangover-libqemu_${version}~${__os_codename}_arm64.deb ./hangover-libwow64fex_${version}_arm64.deb ./hangover-wine_${version}~${__os_codename}_arm64.deb

cat << EOF | sudo tee /usr/local/bin/generate-hangover-prefix >/dev/null
#!/bin/bash
echo

#set up functions
$(declare -f error)
$(declare -f status)
$(declare -f status_green)
$(declare -f warning)
$(declare -f userinput_func)

if [ "\$(id -u)" == 0 ];then
  error "Please don't run this script with sudo."
fi

if [ -z "\$WINEPREFIX" ];then
  WINEPREFIX="\$HOME/.wine"
fi
export WINEPREFIX

if [ -f "\$WINEPREFIX/system.reg" ];then
  registry_exists=true
else
  registry_exists=false
fi

export WINEDEBUG=-virtual #hide harmless memory errors

if [ -e "\$WINEPREFIX" ];then
  status "Checking Wine prefix at \$WINEPREFIX..."
  echo "To choose another prefix, set the WINEPREFIX variable."
  echo -n "Waiting 5 seconds... "
  sleep 5
  echo
  # check for existance of incompatible prefix (see server_init_process https://github.com/wine-mirror/wine/blob/884cff821481b4819f9bdba455217bd5a3f97744/dlls/ntdll/unix/server.c#L1544-L1670)
  # Boot wine and check for errors (make fresh wineprefix)
  output="\$(set -o pipefail; wine wineboot 2>&1 | tee /dev/stderr; )" #this won't display any dialog boxes that require a button to be clicked
  if [ "\$?" != 0 ]; then
    text="Your previously existing Wine prefix failed with an error (see terminal log).

Would you like to remove and regenerate your Wine prefix? Doing so will delete anything you may have installed into your Wine prefix."
    userinput_func "\$text" "No, keep broken Wine prefix and Exit" "Yes, delete and regenerate Wine prefix"
    if [ "\$output" == "No, keep broken Wine prefix and Exit" ]; then
      error "User error: Your current Wine prefix caused Wine to error on launch and you chose to keep it. Manually correct your Wine prefix before installing or updating Wine (x64)."
    fi
    warning "Your previously existing Wine prefix failed with an error (see above). You chose to remove it and so it will be re-generated."
    rm -rf "\$WINEPREFIX"
    registry_exists=false
    wine wineboot #this won't display any dialog boxes that require a button to be clicked
  fi
  #wait until above process exits
  sleep 2
  while [ ! -z "\$(pgrep -i 'wine C:')" ];do
    sleep 1
  done
else
  status "Generating Wine prefix at \$WINEPREFIX..."
  echo "To choose another prefix, set the WINEPREFIX variable."
  echo "Waiting 5 seconds..."
  sleep 5
  # Boot wine (make fresh wineprefix)
  wine wineboot #this won't display any dialog boxes that require a button to be clicked
  #wait until above process exits
  sleep 2
  while [ ! -z "\$(pgrep -i 'wine C:')" ];do
    sleep 1
  done
fi

if [ "\$registry_exists" == false ];then
status "Making registry changes..."
TMPFILE="\$(mktemp)" || exit 1
echo 'REGEDIT4' > \$TMPFILE

echo "  - Disabling Wine mime associations" #see https://askubuntu.com/a/400430

echo '
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices]
"winemenubuilder"="C:\\\\windows\\\\system32\\\\winemenubuilder.exe -r"

[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices]
"winemenubuilder"="C:\\\\windows\\\\system32\\\\winemenubuilder.exe -r"' >> \$TMPFILE

wine regedit \$TMPFILE

rm -f \$TMPFILE
fi #end of if statement that only runs if this script was started when there was no wine registry
true
EOF

sudo chmod +x /usr/local/bin/generate-hangover-prefix
/usr/local/bin/generate-hangover-prefix || exit 1
