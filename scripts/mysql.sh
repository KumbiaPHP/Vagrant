#!/bin/bash

# REMEMBER this config is not for production

# For standalone use
# mysql.sh PASSWORD
if [ $1 ]
then 
    PASSWORD="$1"
fi

# MySQL 
echo "Preparing MySQL "
echo "========================================================================"
apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server mysql-common mysql-client php5-mysql


# /etc/mysql/conf.d/my-local.cnf mejor crear template para esto
MYCONF=$(cat <<EOF
[client]
user = root
password= "${PASSWORD}"

[mysqld]
# Update mysql bind address in /etc/mysql/my.cnf to 0.0.0.0 to allow external connections.
bind-address = 0.0.0.0

EOF
)
# Better don't touch /etc/mysql/my.cnf for updates conflicts
sudo echo "${MYCONF}" > /etc/mysql/conf.d/my.cnf
# TODO add default utf-8 charset

# Assigning root access on %. GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
#sudo mysql -u root "-p$PASSWORD" --execute "grant all on *.* to 'root'@'%';"
sudo mysql --user=root --password="$PASSWORD" -e  "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;FLUSH PRIVILEGES;"

sudo service mysql stop
sudo service mysql start