#!/bin/bash

# --- CHANGE THESE FOR EACH PROJECT ---
PROJECT_NAME="beach_bird_panic"   # Cartridge name without extension
EXPORT_GAME_PATH="./beachbirdpanic.p8.png"     # File on your local machine

# --- CONFIGURATION ---
USER="onion"
HOST="192.168.1.180"
PORT="22"                                # Default SFTP port is 22
REMOTE_DIR="/mnt/SDCARD/Roms/PICO/mine"      # Target folder on the SFTP server

# --- Export Game ---
pico8 "./${PROJECT_NAME}.p8" -export "$EXPORT_GAME_PATH"

echo "Starting SFTP transfer..."

# Run SFTP in batch mode (-b) using standard input redirection (<<EOF)
sftp -P "$PORT" "$USER@$HOST" <<EOF
  cd "$REMOTE_DIR"
  put "$EXPORT_GAME_PATH"
  bye
EOF

# Check exit status of the SFTP command
if [ $? -eq 0 ]; then
    echo "File transferred successfully!"
else
    echo "SFTP transfer failed."
    exit 1
fi