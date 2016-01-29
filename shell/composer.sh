#!/bin/bash

# install Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
echo "Installed composer globally, use: composer"
echo "========================================================================"
echo ""

# go to project folder, load Composer packages (not necessary by default)
#composer install --dev
