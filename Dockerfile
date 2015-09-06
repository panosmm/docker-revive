FROM ubuntu:12.04

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y git curl apache2 php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-gd php5-curl php5-xcache php5-pgsql

# Install app
RUN rm -rf /var/www/*
ADD src /var/www

EXPOSE 80

ADD run.sh /run.sh
ADD site.conf.php /site.conf.php

CMD ["/run.sh"]
CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]
