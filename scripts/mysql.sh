#!/bin/bash

# MySQL 
echo "Preparing MySQL"
echo "========================================================================"
apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server mysql-common mysql-client php5-mysql