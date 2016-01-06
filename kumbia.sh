#!/bin/bash

# KumbiaPHP Ubuntu installer v.01

#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#
export PATH=$PATH:/sbin
export DEBIAN_FRONTEND=noninteractive

REPO='https://github.com/kumbiaphp/kumbiaphp'
PASSWORD='12345678'
FOLDER='kumbia'
LANG="es_ES.UTF-8"
# Install language packs: es de it fr 
lang="es"
# Set default timezone
timezone="Europe/Madrid"

software="apache2 apache2-utils
 mysql-server mysql-common mysql-client
 php5-common php5-cgi php5-mysql php5-mcrypt
 php5-curl php5-sqlite libapache2-mod-php5 phpMyAdmin 
 git htop mc wget"


#----------------------------------------------------------#
#                     Configure system                     #
#----------------------------------------------------------#
# Timezone
sudo timedatectl set-timezone $timezone
echo "Set timezone to $timezone"

# Update system packages
sudo apt-get update
# Disable Upgrade for testing (faster)
sudo apt-get -y upgrade

# Language settings
sudo apt-get -y install "language-pack-$lang"
export LANG="$LANG"

#----------------------------------------------------------#
#                   Install repository                     #
#----------------------------------------------------------#
# Install packages
sudo apt-get -y install $software
if [ $? -ne 0 ]; then
    echo 'Error: apt-get install failed'
    exit 1
fi

sudo php5enmod sqlite3
# install z-ray
# apache installer 3823, php5.5 3833, php 5.6 3843
echo "Downloading z-ray..."
wget -v --progress=bar:force http://www.zend.com/en/download/3833?start=true -O /tmp/zray.tar.gz
sudo tar xvfz /tmp/zray.tar.gz -C /opt
sudo rm /tmp/zray*
sudo cp -r /opt/zray-*/zray /opt/zray
sudo rm -fr /opt/zray-*

sudo cp /opt/zray/zray-ui.conf /etc/apache2/sites-available
sudo a2ensite zray-ui.conf
sudo ln -sf /opt/zray/lib/zray.so /usr/lib/php5/20121212/zray.so
sudo ln -sf /opt/zray/zray.ini /etc/php5/apache2/conf.d/zray.ini
sudo ln -sf /opt/zray/zray.ini /etc/php5/cli/conf.d/zray.ini
sudo chown -R www-data:www-data /opt/zray

# enable headers
sudo a2enmod headers
# enable mod_rewrite
sudo a2enmod rewrite

# create project folder
sudo mkdir "/var/www/html/${FOLDER}"

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


# go to project folder, load Composer packages (not necessary by default)
#cd "/var/www/html/${FOLDER}"
#composer install --dev

# Install Robo
wget -q http://robo.li/robo.phar
sudo chmod +x robo.phar && mv robo.phar /usr/bin/robo
echo "Installed Robo globally, use: robo"

# Install KumbiaPHP Robo file
wget -qO "/var/www/html/${FOLDER}/RoboFile.php" https://raw.githubusercontent.com/KumbiaPHP/Robo-task/master/RoboFile.php

echo "========================================================================"
echo "KumbiaPHP virtual machine ready \o/"
echo "ip: 192.168.10.10"
echo "========================================================================"