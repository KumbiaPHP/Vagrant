#!/bin/bash

echo "======================================================="
echo "Installing PHP7 ..."
echo "======================================================="
# Add the PPA package for php7
sudo add-apt-repository ppa:ondrej/php-7.0 -y
sudo apt-get update -y -q

echo "Uninstalling PHP5 for safety"
echo "======================================================="
# Uninstall php5 for safety
sudo apt-get remove php5  ^php5- -y > /dev/null

# Install php7
sudo apt-get install php7.0 php7.0-mysql $PHP7_MODS -y

# Disable zray don't work with php7
sudo a2dismod z-ray

# Restart apache
sudo service apache stop
sudo service apache start