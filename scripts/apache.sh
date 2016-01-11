#!/bin/bash

# Stop nginx
sudo service nginx stop

echo "==================================================="
echo "Installing apache2..."
echo "==================================================="
# apache2 apache2-utils
sudo apt-get -y install apache2 apache2-utils

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/${FOLDER}"
    <Directory "/var/www/${FOLDER}">
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
sudo service apache2 stop
sudo service apache2 start