#!/bin/bash

# Moving into NPM main directory
cd ..

# Base path assuming the script is launched from main directory
BASE_DIR="$(pwd)"
CONF_DIR="$BASE_DIR/data/nginx/proxy_host"
BACKUP_DIR="$BASE_DIR/backup/$(date +%Y%m%d)"
STATE_FILE="$BASE_DIR/last_cert_used.txt"
SSL_DIR="$BASE_DIR/data/custom_ssl"

# Create the backup directory
mkdir -p "$BACKUP_DIR"

# Display the list of subdirectories with last modification date
echo "List of available certificates:"
find "$SSL_DIR" -mindepth 1 -maxdepth 1 -type d -exec stat --format "%y %n" {} \; | sort -r

echo ""

# Retrieve the last used certificate if it exists
if [[ -f "$STATE_FILE" ]]; then
    LAST_CERT=$(cat "$STATE_FILE")
else
    LAST_CERT="npm-"
fi

# Ask the user for the previous and new certificate names with prepopulation
echo "Enter the previous certificate name (default: $LAST_CERT):"
read -e -i "$LAST_CERT" OLD_CERT

echo "Enter the new certificate name (default: npm-):"
read -e -i "npm-" NEW_CERT

# Verify that values are not empty
if [[ -z "$OLD_CERT" || -z "$NEW_CERT" ]]; then
    echo "Error: Both names must be provided."
    exit 1
fi

# Save the new certificate name for future use
echo "$NEW_CERT" > "$STATE_FILE"

# Backup .conf files
find "$CONF_DIR" -type f -name "*.conf" -exec cp {} "$BACKUP_DIR" \;

echo "Backup completed in folder: $BACKUP_DIR"

# Perform the replacement in all .conf files
find "$CONF_DIR" -type f -name "*.conf" -exec sed -i "s/$OLD_CERT/$NEW_CERT/g" {} +

echo "Replacement completed."
