#!/bin/bash

# KumbiaPHP Ubuntu installer v.01

#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#
export DEBIAN_FRONTEND=noninteractive

FOLDER='kumbia'
echo "Reading config...."
echo "========================================================================"
source /vagrant/config.cfg


#----------------------------------------------------------#
#                     Configure system                     #
#----------------------------------------------------------#
# Timezone
sudo timedatectl set-timezone $timezone
echo "Set timezone to $timezone"
echo "========================================================================"

# Update system packages
sudo apt-get update
# Disable Upgrade for testing (faster)
sudo apt-get upgrade -y

# Language settings
sudo apt-get install "language-pack-$lang" -y
#sudo dpkg-reconfigure locales
export LANG="$LANG"
export LANGUAGE="$LANG"
#export LC_ALL="$LANG"
echo "========================================================================"

#----------------------------------------------------------#
#                   Install repository                     #
#----------------------------------------------------------#


# Install packages
echo "========================================================================"
echo "Downloading & installing packages"
echo "========================================================================"
sudo apt-get install $software -y -q
if [ $? -ne 0 ]; then
    echo 'Error: apt-get install failed'
    exit 1
fi

# Install MySql
source /vagrant/scripts/mysql.sh
# Install phpmyadmin
source /vagrant/scripts/phpmyadmin.sh
# Install z-ray
source /vagrant/scripts/zray.sh


# create project folder
sudo mkdir "/var/www/${FOLDER}"

# git clone KumbiaPHP
sudo git clone $REPO "/var/www/${FOLDER}"

# Permisions for app/temp
sudo chmod -R 755 "/var/www/${FOLDER}/default/app/temp"

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/${FOLDER}/default/public"
    <Directory "/var/www/${FOLDER}/default/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
sudo echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# restart apache
sudo service apache2 restart

# install Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
echo "Installed composer globally, use: composer"
echo "========================================================================"
echo ""

# go to project folder, load Composer packages (not necessary by default)
#cd "/var/www/${FOLDER}"
#composer install --dev

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
echo ""
echo " "
echo "                :::::::   " 
echo "       ####### :::::::    "
echo "      ####### :::::::     "
echo "     ####### :::::::      "
echo "    ####### :::::::       "
echo "   ####### :::::::        "
echo "  ####### :::::::         "
echo " ####### :::::::          "
echo "  ####### :::::::         "
echo "   ####### :::::::        "
echo "    ####### :::::::       "
echo "     ####### :::::::      "
echo "      ####### :::::::     " 
echo "       ####### :::::::    "
echo "                :::::::   "
echo " "                
echo "KumbiaPHP virtual machine ready \o/"
echo " "
echo "      ip: 192.168.10.10"
echo "      Password MySql & phpmyadmin : $PASSWORD"
echo "      MySql port in host: 33066"
echo " "
echo "========================================================================"