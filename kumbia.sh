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

software="apache2 apache2-utils mysql-server mysql-common mysql-client
 php5-common php5-cgi php5-mysql php5-mcrypt
 php5-curl libapache2-mod-php5 phpMyAdmin 
 git htop mc"


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
apt-get -y install "language-pack-$lang"
export LANG="$LANG"

#----------------------------------------------------------#
#                   Install repository                     #
#----------------------------------------------------------#
# Install packages
apt-get -y install $software
if [ $? -ne 0 ]; then
    echo 'Error: apt-get install failed'
    exit 1
fi



# create project folder
sudo mkdir "/var/www/html/${FOLDER}"

# git clone KumbiaPHP
sudo git clone $REPO "/var/www/html/${FOLDER}"

# Permisions for app/temp
chmod -R 755 "/var/www/html/${FOLDER}/default/app/temp"

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${FOLDER}/default/public"
    <Directory "/var/www/html/${FOLDER}/default/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
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

echo "KumbiaPHP virtual machine ready \o/"
echo "ip: 192.168.10.10"
