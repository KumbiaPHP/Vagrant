#!/bin/bash

# Install Robo
wget -q http://robo.li/robo.phar
sudo chmod +x robo.phar && mv robo.phar /usr/bin/robo
echo "Installed Robo globally, use: robo"
echo "========================================================================"
echo ""

# Install KumbiaPHP Robo file
wget -qO "/var/www/${FOLDER}/RoboFile.php" https://raw.githubusercontent.com/KumbiaPHP/Robo-task/master/RoboFile.php
echo "Installed Robofile for KumbiaPHP, use: robo"
echo "========================================================================"