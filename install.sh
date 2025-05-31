#!/bin/bash
# install_updatepro.sh - Installs the configurable updatepro script and
# uses its internal --install option to set up systemd service and timer units.

set -e

echo "Installing updatepro..."

# Ensure the updatepro file exists in the current directory.
if [ ! -f updatepro ]; then
    echo "Error: The updatepro script was not found in the current directory."
    exit 1
fi

# Copy the updatepro script to /usr/local/bin and ensure it's executable.
sudo cp updatepro /usr/local/bin/updatepro
sudo chmod +x /usr/local/bin/updatepro

# Use updatepro's internal installation mode to create the systemd units.
echo "Setting up systemd service and timer units based on your configuration..."
sudo /usr/local/bin/updatepro --install

echo "updatepro has been installed successfully!"
echo "You can update the configuration by running: sudo /usr/local/bin/updatepro --configure"
echo "To check the systemd timer status, use: sudo systemctl status updatepro.timer"
