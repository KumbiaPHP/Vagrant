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
#sudo mv /var/www/kumbia/{.[!.],}* /var/www
#sudo rm /var/www/kumbia*
sudo rm /var/www/kumbia/.htaccess
# Permisions for app/temp
sudo chmod -R 755 "/var/www/kumbia/default/app/temp"

#----------------------------------------------------------#
#                  Use config for install stack            #
#----------------------------------------------------------#

# Install apache or nginx ?
if [ $nginx ]; then
    # Install & configure Nginx
    source /vagrant/scripts/nginx.sh
    # Add load php-fpm
else
    # Install & configure Apache
    source /vagrant/scripts/apache.sh
fi

# Install php5.5 or php7 ?
if [ $PHP7 ]; then
    # Install & configure PHP7
    source /vagrant/scripts/php7.sh
    # Add load php-fpm
else
    # Install & configure php5.5
    source /vagrant/scripts/php5.sh
    
    # Install z-ray
    source /vagrant/scripts/zray.sh
fi

# Install MySql
#source /vagrant/scripts/mysql.sh
# The PPA require PHP5, better change for git o composer

# Install adminer for db administration
source /vagrant/scripts/adminer.sh

# Install Composer
source /vagrant/scripts/composer.sh

# Install Robo & KumbiaPHP robofile
source /vagrant/scripts/robofile.sh

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