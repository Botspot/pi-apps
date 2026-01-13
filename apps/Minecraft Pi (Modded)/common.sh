# App ID
ID='com.thebrokenrail.MCPIReborn'
OLD_ID="${ID}Client"

# Binary Directory
BIN="${HOME}/.local/bin"
mkdir -p "${BIN}" || error "Could not make directory"

# AppImage Location
APPIMAGE="${BIN}/${ID}.AppImage"

# Cleanup Old Versions
sudo rm -f /etc/apt/trusted.gpg.d/mcpi-revival.gpg
sudo rm -f /etc/apt/sources.list.d/mcpi-revival.list
remove() {
    if package_installed "$1"; then
        apt_lock_wait
        sudo apt-get remove -y "$1"
    fi
}
remove gmcpil
remove jmcpil
remove minecraft-pi-reborn-client
rm -f "${HOME}/.local/share/applications/${OLD_ID}.desktop"
rm -f "${BIN}/${OLD_ID}.AppImage"
