#!/bin/bash
# updatepro - Automatically check for updates for pacman and flatpak every 15 minutes
# and send a notification when packages have been updated.

# Function to send notifications.
send_notification() {
    title="$1"
    message="$2"
    # If running as root, try to send the notification as the logged‐in user.
    if [ "$EUID" -eq 0 ]; then
        user=$(logname)
        # Assumes the display is :0 – adjust DISPLAY and XAUTHORITY if needed.
        sudo -u "$user" DISPLAY=:0 notify-send "$title" "$message"
    else
        notify-send "$title" "$message"
    fi
}

while true; do
    updated_packages=""

    echo "Checking for pacman updates..."
    # Check for available pacman updates.
    # pacman -Qu prints only foreign/outdated packages.
    pacman_updates=$(pacman -Qu 2>/dev/null)
    if [ -n "$pacman_updates" ]; then
        echo "Updating pacman packages..."
        # Update the system with no confirmation.
        sudo pacman -Syu --noconfirm
        updated_packages+="Pacman "
    fi

    echo "Checking for flatpak updates..."
    # Attempt a flatpak update in noninteractive mode
    flatpak_output=$(flatpak update --assumeyes --noninteractive 2>&1)
    # If the output does NOT state "No updates", then assume updates were applied.
    if ! echo "$flatpak_output" | grep -q "No updates"; then
        # The flatpak command both checks and applies updates here.
        updated_packages+="Flatpak "
    fi

    if [ -n "$updated_packages" ]; then
        send_notification "updatepro" "The following packages have been updated: $updated_packages"
    else
        echo "No updates available at $(date)."
    fi

    # Wait for 15 minutes (900 seconds) before checking again.
    sleep 900
done
