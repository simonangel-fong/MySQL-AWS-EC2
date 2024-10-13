#!/bin/bash

# parameters
config_file="/etc/mysql/mysql.conf.d/mysqld.cnf"
new_user="newuser"
new_user_password="newpwd"

# upgrade OS
sudo apt update -y && sudo apt upgrade -y

# install MySQL package
sudo apt install mysql-server -y

# allow remote access
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' "$config_file"

# Restart MySQL service to apply changes
sudo systemctl restart mysql
# To ensure  MySQL starts automatically at boot
sudo systemctl enable mysql.service

# Execute SQL commands
# sudo mysql -u root -p <<EOF
sudo mysql <<EOF
CREATE USER '$new_user'@'%' IDENTIFIED BY '$new_user_password';
GRANT ALL PRIVILEGES ON *.* TO '$new_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Update Firewall Rules
# Setting Up Default Policies
sudo ufw disable
# deny incoming
sudo ufw default deny incoming
# allow outgoing
sudo ufw default allow outgoing
# allow port of mysql
sudo ufw allow 3306/tcp
sudo ufw allow 22
# verify which rules were added
sudo ufw show added
sudo echo "y" | sudo ufw enable
sudo ufw status verbose
