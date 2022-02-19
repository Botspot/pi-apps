#!/bin/bash

#remove the menu launcher
rm -f ~/.local/share/applications/tor.desktop

#before removing the tor-browser_en-US folder, move the browser configuration like bookmarks, etc
if [ -d ~/tor-browser_en-US ];then
  mkdir -p ~/tor-browser_en-US.temp/Browser/TorBrowser/Data
  mv -n ~/tor-browser_en-US/Browser/TorBrowser/Data/Browser ~/tor-browser_en-US.temp/Browser/TorBrowser/Data
fi

#remove all browser internals (except for user-data which we moved already)
rm -rf ~/tor-browser_en-US

#move back the temporary folder containing user-data
if [ -d ~/tor-browser_en-US.temp ];then
  mv ~/tor-browser_en-US.temp ~/tor-browser_en-US

  #let the user know where configuration is
  echo "Tor Browser has been uninstalled, but user-data like settings and bookmarks remain intact.
To remove these files, run this command:
rm -rf ~/tor-browser_en-US"
  
fi
