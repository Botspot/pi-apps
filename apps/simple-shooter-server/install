#!/bin/bash
APPDIR="$HOME/.local/share/simple-shooter-server"
DESKTOPFILE="$HOME/.local/share/applications/simple-shooter-server.desktop"
ZIP_URL="https://drive.google.com/uc?export=download&id=1pGhRYJxymjfEDKbxtI-hJdsNHH-y4vKI"

if [ ! -d "$APPDIR" ]; then
  echo "Installing Simple Shooter Server..."
  mkdir -p "$APPDIR"
  cd "$APPDIR"

  # Download with confirmation token handling
  CONFIRM=$(curl -sc /tmp/gcookie "https://drive.google.com/uc?export=download&id=1pGhRYJxymjfEDKbxtI-hJdsNHH-y4vKI" | grep -o 'confirm=[^&]*' | sed 's/confirm=//')
  curl -Lb /tmp/gcookie "https://drive.google.com/uc?export=download&confirm=$CONFIRM&id=1pGhRYJxymjfEDKbxtI-hJdsNHH-y4vKI" -o server.zip

  unzip -o server.zip
  rm server.zip

  chmod +x start.sh

  # Create .desktop file
  echo "[Desktop Entry]
  Name=Simple Shooter Server
  Exec=lxterminal -e /bin/bash -c 'cd \$HOME/.local/share/simple-shooter-server && ./start.sh'
  Icon=path_to_icon.png
  Terminal=false
  Type=Application
  Categories=Game;" > "$DESKTOPFILE"

  chmod +x "$DESKTOPFILE"

  echo "Installation complete."
fi

echo "Starting Simple Shooter Server..."
cd "$APPDIR"
./start.sh
