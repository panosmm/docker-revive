#!/bin/bash -le

# If the site config file does not exist, create and symlink it.
if [ ! -f /config/${SITE}.conf.php ] ; then
	cp /site.conf.php /config/${SITE}.conf.php
	sed -i s/'SITE'/${SITE}/ /config/${SITE}.conf.php
	sed -i s/'PASSWORD'/${PASSWORD}/ /config/${SITE}.conf.php
	sed -i s/'USERNAME'/${USERNAME}/ /config/${SITE}.conf.php
	chown www-data /config/${SITE}.conf.php
fi
chmod -R a+w /var/www/timber/var
ln -sf /config/${SITE}.conf.php /var/www/timber/var/${SITE}.conf.php

# Create the banner storage directory and ensure it is owned by www-data
if [ ! -d /config/www/images/ ] ; then
	mkdir -p /config/www/images
	chown www-data /config/www/images
fi
# Copy over the standard contents of the images directory
cp -ar /var/www/timber/www/images/ /config/www/images/

# Add msmtp config file with variable replacement
# cat /tmp/msmtprc| sed s/EMAIL/${EMAIL}/g | sed s/SMTP_SERVER/${SMTP_SERVER}/g > /etc/msmtprc

# Start Apache

/usr/sbin/apache2 -D FOREGROUND

<<COMMENT1
/etc/init.d/apache2 start
touch /tmp/last-reload
#Trap SIGHUP to reload Apache
trap "/etc/init.d/apache2 reload" SIGHUP

touch /config/www/do-reload
touch /tmp/last-reload
#Check if there exists at-least 1 process running as haproxy user.
while ps -u www-data 1>/dev/null ;
do
  sleep 20s
  if [ /config/www/do-reload -nt /tmp/last-reload ]; then
	/etc/init.d/apache2 reload
	touch /tmp/last-reload
  fi
done

echo "Apache heartbeat did not succeed. Exiting...."
COMMENT1
