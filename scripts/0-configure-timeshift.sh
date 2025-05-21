#!/bin/bash
# Script to configure Timeshift for BTRFS

set -e

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 
    exit 1
fi

echo "Installing Timeshift..."
pacman -S --noconfirm timeshift || { echo "Failed to install Timeshift"; exit 1; }

echo "Configuring Timeshift for BTRFS..."

# Create the Timeshift configuration directory if it doesn't exist
mkdir -p /etc/timeshift

# Create a basic BTRFS configuration
cat > /etc/timeshift/timeshift.json << EOL
{
  "backup_device_uuid" : "",
  "parent_device_uuid" : "",
  "do_first_run" : "true",
  "btrfs_mode" : "true",
  "include_btrfs_home" : "false",
  "schedule_monthly" : "false",
  "schedule_weekly" : "true",
  "schedule_daily" : "true",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "2",
  "count_weekly" : "3",
  "count_daily" : "5",
  "count_hourly" : "6",
  "count_boot" : "5",
  "snapshot_size" : "0",
  "snapshot_count" : "0",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  "exclude" : [
  ],
  "exclude-apps" : [
  ]
}
EOL

echo "Timeshift configured for BTRFS. Please run 'sudo timeshift-gtk' to complete the setup and create your first snapshot."