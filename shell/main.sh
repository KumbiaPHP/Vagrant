#!/bin/bash

# KumbiaPHP Ubuntu installer v.01

#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#
export DEBIAN_FRONTEND=noninteractive

echo "Reading config...."
echo "========================================================================"
source /vagrant/config.cfg

# Hack for php5-fpm bug https://bugs.launchpad.net/ubuntu/+source/php5/+bug/1242376
# sudo echo "reload signal SIGUSR2" > /etc/init/php5-fpm.override

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
export LANG="$LANGUAGE"
export LANGUAGE="$LANGUAGE"
#export LC_ALL="$LANGUAGE"
echo "========================================================================"

# For use debconf selections
sudo apt-get install debconf-utils -y

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

#----------------------------------------------------------#
#          Install last KumbiaPHP 1.0 from github          #
#----------------------------------------------------------#

# git clone KumbiaPHP
sudo git clone $REPO "/var/www/kumbia"
sudo rm /var/www/kumbia/.htaccess
# Install kumbia favicon :)
sudo cp /var/www/kumbia/default/public/favicon.ico /var/www/kumbia
# Permisions for app/temp
sudo chmod -R 755 "/var/www/kumbia/default/app/temp"

#----------------------------------------------------------#
#                  Use config for install stack            #
#----------------------------------------------------------#

# Install apache or nginx ?
if [ $nginx ]; then
    # Install & configure Nginx
    source /vagrant/shell/nginx.sh
    # Add load php-fpm
else
    # Install & configure Apache
    source /vagrant/shell/apache.sh
fi

# Install php5.5 or php7 ?
if [ $PHP7 ]; then
    # Install & configure PHP7
    source /vagrant/shell/php7.sh
    # Add load php-fpm
else
    # Install & configure php5.5
    source /vagrant/shell/php5.sh
    
    # Install z-ray
    source /vagrant/shell/zray.sh
fi


# Install prettying up apache directory listings, based in apaxy
# while finising the kumbia index.php
sudo cp -r /vagrant/shell/templates/share/. /var/www/kumbia

# Install MySql
source /vagrant/shell/mysql.sh $PASSWORD


# Install adminer for db administration
source /vagrant/shell/adminer.sh

# Install Composer
source /vagrant/shell/composer.sh

# Install Robo & KumbiaPHP robofile
source /vagrant/shell/robofile.sh

sudo ln -s /vagrant/shell/a2createvhost.sh /usr/local/sbin
sudo chmod +x /usr/local/sbin/a2createvhost

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
echo "KumbiaPHP virtual machine ready ¯\_(ツ)_/¯ "
echo " "
echo "      ip: 192.168.10.10"
echo "      Password MySql: $PASSWORD"
echo " "
echo "========================================================================"