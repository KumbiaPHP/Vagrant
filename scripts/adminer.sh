#!/bin/bash

echo "Installing Admirer db administration"
echo "==================================================================="

sudo wget -O /var/www/adminer.php https://www.adminer.org/latest.php
# Chose your style in https://www.adminer.org/
sudo wget -O /var/www/adminer.css https://raw.githubusercontent.com/vrana/adminer/master/designs/ng9/adminer.css
