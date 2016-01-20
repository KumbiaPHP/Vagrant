#!/bin/bash

# For standalone use
# nginx.sh php7

PHP7=${1:-true}   
#source /vagrant/config.cfg
# HACK for the php5-fpm
# For now nginx always use php7


# if apache is running
if pidof apache2 > /dev/null
then
    # Stop apache2
    sudo service apache2 stop
fi

# if nginx is installed
if hash nginx 2>/dev/null
then
    # Start nginx
    sudo service nginx restart
    exit 0
fi

# Nginx
echo "Installing Nginx"
echo "========================================================================"
sudo apt-get install nginx -y

# Install php5.5 or php7 fpm?
if [ $PHP7 ]
then
    # Install & configure PHP7
    source /vagrant/shell/php7.sh nginx
    sudo apt-get install php7.0-fpm -y
else
    # Install & configure php5.5
    source /vagrant/shell/php5.sh nginx
    sudo apt-get install php5-fpm -y
fi

# Start nginx
sudo service nginx restart

