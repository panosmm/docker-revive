#!/bin/bash -le

# If the site confir file does not exist, create and symlink it.
if [ ! -f /config/${SITE}.conf.php ] ; then
	cp /site.conf.php /config/${SITE}.conf.php
	sed -i s/'SITE'/${SITE}/ /config/${SITE}.conf.php
	sed -i s/'PASSWORD'/${PASSWORD}/ /config/${SITE}.conf.php
	sed -i s/'USERNAME'/${USERNAME}/ /config/${SITE}.conf.php
	chown www-data /config/${SITE}.conf.php
fi
ln -sf /config/${SITE}.conf.php /var/www/timber/var/${SITE}.conf.php

# Create the banner storage directory and ensure it is owned by www-data
if [ ! -d /config/www/images/ ] ; then
	mkdir -p /config/www/images
	chown www-data /config/www/images
fi
# Copy over the standard contents of the images directory
cp -ar /var/www/timber/www/images/ /config/www/images/

# Add msmtp config file with variable replacement
cat /tmp/msmtprc| sed s/EMAIL/${EMAIL}/g | sed s/SMTP_SERVER/${SMTP_SERVER}/g > /etc/msmtprc
