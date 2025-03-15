#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display messages
show_message() {
  echo -e "${YELLOW}$1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root${NC}"
  exit 1
fi

# Stop MySQL if it's running
show_message "Stopping MySQL service if running..."
systemctl stop mysql
killall -9 mysqld mysqld_safe 2>/dev/null || true

# Completely purge MySQL
show_message "Removing existing MySQL installation..."
apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
apt-get autoremove -y
apt-get autoclean -y

# Remove MySQL directories
show_message "Cleaning up MySQL directories..."
rm -rf /etc/mysql /var/lib/mysql /var/log/mysql /var/run/mysqld

# Install MySQL Server
show_message "Installing MySQL Server..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

# Create required directories
show_message "Creating required directories..."
mkdir -p /var/run/mysqld
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 755 /var/run/mysqld
chmod 750 /var/lib/mysql

# Initialize MySQL with a secure installation
show_message "Initializing MySQL data directory..."
mysqld --initialize-insecure --user=mysql

# Start MySQL service
show_message "Starting MySQL service..."
systemctl start mysql

# Set root password to "password"
show_message "Setting root password to 'password'..."
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password'; FLUSH PRIVILEGES;"

# Check if MySQL is working
if mysql -u root -ppassword -e "SELECT 'MySQL is working properly'" > /dev/null 2>&1; then
  echo -e "${GREEN}MySQL has been successfully installed and root password set to 'password'${NC}"
  echo -e "${GREEN}You can now connect with: mysql -u root -ppassword${NC}"
else
  echo -e "${RED}MySQL installation failed. Please check the logs.${NC}"
fi

# Enable MySQL to start on boot
systemctl enable mysql

show_message "MySQL installation and configuration completed!"