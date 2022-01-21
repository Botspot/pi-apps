#!/bin/bash

shopt -s extglob

#skip uninstallation if executed from an update
if [[ "$1" != "update" ]];then
    cd $HOME/Minecraft-Java-Server && rm -rf !(world|mods|versions)
    rm -rf $HOME/.local/share/applications/Minecraft-Java-Server.desktop || error "Failed to remove the desktop file"
    # stop the server
    sudo systemctl stop minecraft-server
    # disable server from starting on boot
    sudo systemctl disable minecraft-server
    
    # remove the systemd service
    sudo rm -f /etc/systemd/system/minecraft-server.service
    sudo systemctl daemon-reload
    
    purge_packages || error "Dependencies failed to uninstall"
    remove_repofile_if_unused /etc/apt/sources.list.d/adoptium.list
    remove_repofile_if_unused /etc/apt/sources.list.d/adoptopenjdk.list
else
    echo "Uninstall skipped because run from the updater"
fi
