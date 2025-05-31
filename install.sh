#!/bin/bash
# install_updatepro.sh - Installs updatepro and sets up a systemd timer to run it every 15 minutes.

set -e

echo "Installing updatepro..."

# Copy the updatepro script to /usr/local/bin
sudo cp updatepro /usr/local/bin/updatepro
sudo chmod +x /usr/local/bin/updatepro

# Create the systemd service unit.
sudo tee /etc/systemd/system/updatepro.service > /dev/null <<'EOF'
[Unit]
Description=Automatically check for pacman and flatpak updates with updatepro

[Service]
Type=simple
# If run as root, the script itself manages re-routing notifications to the logged in user.
ExecStart=/usr/local/bin/updatepro
Restart=always
RestartSec=60
EOF

# Create the systemd timer unit.
sudo tee /etc/systemd/system/updatepro.timer > /dev/null <<'EOF'
[Unit]
Description=Run updatepro every 15 minutes

[Timer]
OnBootSec=15min
OnUnitActiveSec=15min
Unit=updatepro.service

[Install]
WantedBy=timers.target
EOF

# Reload the systemd manager configuration.
sudo systemctl daemon-reload

# Enable and start the timer.
sudo systemctl enable updatepro.timer
sudo systemctl start updatepro.timer

echo "updatepro has been installed."
echo "It will now be automatically run every 15 minutes via systemd."
echo "To check its status, use: sudo systemctl status updatepro.timer"
