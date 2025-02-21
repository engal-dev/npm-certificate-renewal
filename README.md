# Replace Nginx SSL Certificate Script

## Overview

This Bash script automates the process of replacing SSL certificate names inside Nginx configuration files used by Nginx Proxy Manager. It ensures a smooth transition by:

- Listing available SSL certificates with their last modification date.
- Backing up all `.conf` files before making any changes.
- Allowing the user to replace an old certificate name with a new one.
- Storing the last used certificate name to simplify future executions.

## How It Works

1. The script displays all subdirectories inside `data/custom_ssl/` along with their last modification date to help identify the correct certificate.
2. The user is prompted to enter the old certificate name (pre-filled with the last used one if available).
3. The user enters the new certificate name (default prefix: `npm-`).
4. The script backs up all `.conf` files from `data/nginx/proxy_host/` to `backup/YYYYMMDD/`.
5. The script replaces occurrences of the old certificate name with the new one inside all `.conf` files.
6. The new certificate name is stored for the next execution.

## Usage

### Prerequisites

- Before running the script, make sure to upload the new certificate as a Custom SSL certificate via the Nginx Proxy Manager interface:
  1. Go to **SSL Certificates**.
  2. Click **Add SSL Certificate**.
  3. Select **Custom** and upload the required certificate and key.

- The script should be executed from within the `nginx-proxy-manager` directory.
- Ensure you have the necessary permissions to modify files within the directory.

### Running the Script

1. Stop the service of NPM
2. Open a terminal and navigate to the main `nginx-proxy-manager` directory
3. Make the script executable (only required the first time):
   ```sh
   chmod +x replace_cert_nginx.sh
   ```
4. Run the script:
   ```sh
   ./replace_cert_nginx.sh
   ```
5. Follow the on-screen prompts to select the certificate names
6. Restart the service of NPM.

## Backup and Safety Measures

- The script automatically creates a backup of all `.conf` files before modifying them.
- The backups are stored in `backup/YYYYMMDD/` format to prevent overwriting previous backups.
- If any input is left empty, the script will halt to avoid unintended replacements.

## Notes

- The script assumes the certificate names follow the `npm-XX` format.
- If you wish to start fresh, delete `last_cert_used.txt` to remove the last saved certificate name.

## License

This script is open-source and provided as-is. Use at your own risk.
