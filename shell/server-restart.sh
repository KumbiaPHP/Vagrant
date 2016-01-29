#!/bin/bash

# if apache is running
if pidof apache2 > /dev/null
then
    # Restart apache
    sudo service apache2 restart
fi
# if nginx is running
if pidof nginx > /dev/null
then
    sudo service nginx restart
fi