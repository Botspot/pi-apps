#!/bin/bash
output="$(sudo apt update 2>&1)"
exitcode=$?

#inform user packages are upgradeable
if [ -z "$(echo "$output" | grep 'packages can be upgraded' )" ];then
  exit 0
fi
#only continue script if upgrades available


LIST="$(apt list --upgradable 2>/dev/null | cut -d/ -f 1 | tail -n +2)"

echo -e "$LIST" | yad --center --title='Update Buddy' --width=310 --height=300 --no-headers \
  --list --separator='\n' --window-icon="${DIRECTORY}/icons/logo.png" \
  --text='These packages can be upgraded:' \
  --column=Package \
  --button='Cancel'!"${DIRECTORY}/icons/exit.png"!:1 \
  --button='Update now'!"${DIRECTORY}/icons/download.png":0 \
  2>/dev/null || exit 0
  
lxterminal --title='Upgrading packages' -e 'sudo apt -y full-upgrade;echo "Closing in 10 seconds.";sleep 10'
