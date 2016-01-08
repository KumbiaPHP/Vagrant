#!/bin/bash

# Uninstall php7 for safety
sudo apt-get remove php7.0  ^php7.0 -y -q

echo "======================================================="
echo "Installing PHP5 ..."
echo "======================================================="
sudo apt-get install php5 $PHP5_MODS -y

sudo php5enmod $PHP5_MODS
