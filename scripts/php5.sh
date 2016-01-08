#!/bin/bash

# For standalone use
# php5.sh MODULE1 MODULE2 ...
# TODO mejorar este hack
if [ ! $1 ]
then 
    source /vagrant/config.cfg
fi

# Uninstall php7 for safety
sudo apt-get remove php7.0  ^php7.0 -y -q

echo "======================================================="
echo "Installing PHP5 ..."
echo "======================================================="
sudo apt-get install php5 $PHP5_MODS -y

sudo php5enmod $PHP5_MODS
                 
