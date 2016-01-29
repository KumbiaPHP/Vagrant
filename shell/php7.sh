#!/bin/bash

# For standalone use
# php7.sh MODULE1 MODULE2 ... 
# TODO mejorar este hack, y posible tener mas configs
if [ ! $1 ]
then 
    source source /vagrant/config.cfg
fi

# if php5 is installed
if hash php5 2>/dev/null
then
    echo "Uninstalling PHP5 for safety"
    echo "======================================================="
    # Uninstall php5 for safety
    sudo apt-get remove php5  ^php5- -y -q

    # Disable zray don't work with php7
    sudo a2dismod z-ray
fi

echo "======================================================="
echo "Installing PHP7 ..."
echo "======================================================="
# Add the PPA package for php7
sudo add-apt-repository ppa:ondrej/php-7.0 -y
sudo apt-get update -y -q



# Install php7
sudo apt-get install php7.0 php7.0-mysql $PHP7_MODS -y

source /vagrant/shell/server-restart.sh