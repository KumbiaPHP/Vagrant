#!/bin/bash


# For standalone use
# apache.sh
# TODO Mejorar este hack
if [ $1 ]
then 
    VHOST="$1"
else
    source /vagrant/config.cfg
fi

# if nginx is running
if pidof nginx > /dev/null
then
    # Stop nginx
    sudo service nginx stop
    # Stop php-fpm
    sudo service php5-fpm stop
    sudo service php7.0-fpm stop
fi

# if apache2 is installed
if hash apache2 2>/dev/null
then
    # restart apache
    sudo service apache2 restart
    exit 0
fi

echo "==================================================="
echo "Installing apache2..."
echo "==================================================="
# apache2 apache2-utils
sudo apt-get -y install apache2 apache2-utils

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/kumbia"
    <Directory "/var/www/kumbia">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)

#sudo echo "$(source /vagrant/scripts/templates/apache_host)" > /etc/apache2/sites-available/000-default.conf

sudo echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# Disabled, problem with dir javascript from KumbiaPHP
sudo a2disconf javascript-common
               
# enable headers
sudo a2enmod headers
# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
sudo service apache2 restart
   