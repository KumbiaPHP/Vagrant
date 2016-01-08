#!/bin/bash

# Stop apache2
sudo service apache2 stop

# Nginx
echo "Installing Nginx"
echo "========================================================================"
apt-get install nginx -y

# Start nginx
sudo service nginx start

