#!/bin/bash

# For standalone use
# phpmyadmin.sh PASSWORD
# TODO mejorar este hack, y posible tener mas configs
if [ ! $1 ]
then 
    source /vagrant/config.cfg
fi

# install phpmyadmin
echo "Preparing phpmyadmin "
echo "========================================================================"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo debconf-set-selections <<< "phpmyadmin	phpmyadmin/dbconfig-remove boolean false"
sudo debconf-set-selections <<< "phpmyadmin	phpmyadmin/purge boolean	false"
sudo apt-get -y -q install phpmyadmin mcrypt