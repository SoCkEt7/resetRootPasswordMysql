# MySQL Reset Script

A bash script that automatically installs and configures MySQL with a predefined root password. Completely removes existing installations, sets up a fresh copy with proper permissions, and verifies everything is working.

## Problem

MySQL can sometimes become corrupted or have password issues that are difficult to resolve. This often leads to frustrating troubleshooting sessions trying to:
- Reset forgotten root passwords
- Fix socket connection issues
- Repair corrupted data files
- Resolve permission problems

## Solution

This script automates the complete reset and reinstallation process in one simple command.

## Features

- 🧹 Completely removes existing MySQL installations
- 📦 Installs a fresh copy of MySQL server
- 🔑 Sets up proper directory permissions
- 🔄 Initializes a new MySQL data directory
- 🔒 Configures root password to "password" (customizable)
- ✅ Verifies installation is working properly
- 🚀 Enables MySQL to start automatically on boot

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/mysql-reset-script.git
cd mysql-reset-script

# Make the script executable
chmod +x mysql_install.sh
```

## Usage

```bash
# Run the script with sudo
sudo ./mysql_install.sh
```

## What happens during execution

1. **Preparation**:
    - Stops any running MySQL instances
    - Kills any remaining MySQL processes

2. **Cleanup**:
    - Removes all MySQL packages
    - Deletes configuration and data directories
    - Runs autoremove and autoclean

3. **Installation**:
    - Updates package repositories
    - Installs MySQL server package
    - Creates required directories with proper permissions

4. **Configuration**:
    - Initializes MySQL data directory
    - Starts MySQL service
    - Sets root password to "password"
    - Enables MySQL to start on boot

5. **Verification**:
    - Tests connection to MySQL
    - Confirms proper operation

## Customization

You can easily modify the root password by changing the following line in the script:

```bash
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password'; FLUSH PRIVILEGES;"
```

## Requirements

- Debian-based Linux distribution (Ubuntu, Debian, etc.)
- Root or sudo privileges

## Troubleshooting

If you encounter issues:

1. Check the MySQL error log:
   ```bash
   sudo tail -f /var/log/mysql/error.log
   ```

2. Verify MySQL is running:
   ```bash
   sudo systemctl status mysql
   ```

3. Check for remaining processes:
   ```bash
   ps aux | grep mysql
   ```

## License

MIT

## Disclaimer

This script is provided as-is without any warranty. It will completely remove your existing MySQL installation and data. Use at your own risk and ensure you have backups of any important databases.