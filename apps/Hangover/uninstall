#!/bin/bash

pkill -9 wine
command -v wineserver >/dev/null && wineserver -k

status -n "Removing terminal commands... "
sudo rm -rf /usr/local/bin/generate-hangover-prefix
status_green "Done"

status -n "Removing mimetypes... "
#See: https://askubuntu.com/a/400430
rm -f ~/.local/share/mime/packages/x-wine*
rm -f ~/.local/share/applications/wine-extension*
rm -f ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*
rm -f ~/.local/share/mime/application/x-wine-extension*
status_green "Done"

purge_packages || exit 1

if [ -e "$HOME/.wine" ];then
  echo -e "\n\n\e[93mYou just uninstalled the Hangover app, but it's not completely gone yet.
To prevent data loss, your Wine configuration is still\nlocated in the $HOME/.wine folder. Feel free to delete it to save space or to rename the folder for troubleshooting.\e[39m\n"
fi
true
