#!/bin/bash

# install z-ray
# apache installer 3823, php5.5 3833, php 5.6 3843
echo "========================================================================"
echo "Downloading z-ray..."
echo "========================================================================"
wget -v -N --progress=bar:force http://www.zend.com/en/download/3833?start=true -O /tmp/zray.tar.gz
echo "Installing z-ray..."
echo "========================================================================"
sudo tar xfz /tmp/zray.tar.gz -C /opt
#sudo rm /tmp/zray*
sudo cp -r /opt/zray-*/zray /opt/zray
sudo rm -fr /opt/zray-*

sudo cp /opt/zray/zray-ui.conf /etc/apache2/sites-available
sudo a2ensite zray-ui.conf
sudo ln -sf /opt/zray/lib/zray.so /usr/lib/php5/20121212/zray.so
sudo ln -sf /opt/zray/zray.ini /etc/php5/apache2/conf.d/zray.ini
sudo ln -sf /opt/zray/zray.ini /etc/php5/cli/conf.d/zray.ini
sudo chown -R www-data:www-data /opt/zray

source /vagrant/scripts/server-restart.sh