#!/bin/bash

# Cleanup Old Script Versions
rm -f /etc/apt/trusted.gpg.d/mcpi-revival.gpg
rm -f /etc/apt/sources.list.d/mcpi-revival.list
sudo apt-get uninstall -y gmcpil jmcpil minecraft-pi-reborn-client || :

# Download file
mkdir -p ~/.local/bin || error "Could not make directory"
wget -O ~/.local/bin/com.thebrokenrail.MCPIRebornClient.AppImage "${url}"
chmod +x ~/.local/bin/com.thebrokenrail.MCPIRebornClient.AppImage

enable_module fuse || exit 1

# Make Desktop file
mkdir -p ~/.local/share/applications || error "Could not make directory"
echo "[Desktop Entry]
Name=Minecraft: Pi Edition: Reborn (Client)
Comment=Fun with Blocks
Icon=$(dirname "$0")/icon-64.png
StartupNotify=false
StartupWMClass=Minecraft: Pi Edition: Reborn
Exec=${HOME}/.local/bin/com.thebrokenrail.MCPIRebornClient.AppImage
Terminal=false
Type=Application
Categories=Game;" > ~/.local/share/applications/com.thebrokenrail.MCPIRebornClient.desktop
