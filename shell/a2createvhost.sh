#!/bin/bash
set -e
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# 
if [ $1 ]
then 
    VHOST="$1"
else
    echo "Vhost name:"
    read VHOST
fi

template=/vagrant/shell/templates/apache_vhost.txt

# when no directory, copy default kumbia app
if [ ! -d "/var/www/kumbia/${VHOST}" ]
then
    sudo mkdir "/var/www/kumbia/${VHOST}"
    sudo cp -r /var/www/kumbia/default/. "/var/www/kumbia/${VHOST}"
fi

# setup hosts file
sudo sed "s/{VHOST}/$VHOST/g" $template > "/etc/apache2/sites-available/${VHOST}.conf"

sudo a2ensite $VHOST
# restart apache
sudo service apache2 restart

echo "==================================================="
echo "Created apache2 vhost: ${VHOST}"
echo ""
echo "Add to your hosts file:"
echo "192.168.10.10 ${VHOST}"
echo "==================================================="
   