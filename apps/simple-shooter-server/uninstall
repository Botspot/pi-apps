#!/bin/bash
APPDIR="$HOME/.local/share/simple-shooter-server"
DESKTOPFILE="$HOME/.local/share/applications/simple-shooter-server.desktop"

echo "Uninstalling Simple Shooter Part 3..."

if [ -d "$APPDIR" ]; then
  rm -rf "$APPDIR"
  echo "Removed application files."
else
  echo "Application files not found."
fi

if [ -f "$DESKTOPFILE" ]; then
  rm "$DESKTOPFILE"
  echo "Removed desktop shortcut."
else
  echo "Desktop shortcut not found."
fi

echo "Uninstall complete."
