FROM ubuntu:14.04
MAINTAINER Bealox "thebealox@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install apache2 git curl php5 php5-mcrypt php5-json php5-mcrypt && apt-get autoremove && apt-get clean

RUN /usr/sbin/a2enmod rewrite

RUN /usr/sbin/a2enmod socache_shmcb || true

RUN echo "extension=mcrypt.so" >> /etc/php5/apache2/conf.d/20-mcrypt.ini
RUN echo "extension=mcrypt.so" >> /etc/php5/cli/conf.d/20-mcrypt.ini

ADD config/default /etc/apache2/sites-available/000-default.conf
ADD config/default-ssl /etc/apache2/sites-available/default-ssl.conf

RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN /usr/local/bin/composer create-project laravel/laravel /var/www/laravel --prefer-dist
RUN /bin/chown www-data:www-data -R /var/www/laravel/app/storage

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
