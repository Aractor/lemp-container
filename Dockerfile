FROM debian:latest
MAINTAINER Aractor 'd Factor
ENV APP_NAME="Debian LEMP Stack"

WORKDIR /usr/src/LEMP

RUN apt-get update && apt-get -y install \
	nginx \
	mariadb-server \
	mariadb-client \
	expect

CMD systemctl stop nginx.service \
	&& systemctl start nginx.service \
	&& systemctl enable nginx.service \
	&& systemctl stop mariadb.service \
	&& systemctl start mariadb.service \
	&& systemctl enable mariadb.service

COPY mysql_secure.exp .
CMD expect mysql_secure.exp
RUN apt-get -y purge expect \
	&& apt-get -y autoremove

RUN apt-get -y install \
	php \
 	php-json \
	php-fpm \
	php-common \
	php-mbstring \
	php-xmlrpc \
	php-soap \
	php-gd \
	php-xml \
	php-intl \
	php-mysql \
	php-cli \
	php-zip \
	php-curl
	
COPY php.ini /etc/php/*/fpm/php.ini

COPY www/* /var/www/html/
COPY default /etc/nginx/sites-available/
CMD systemctl stop php*-fpm.service \
	&& systemctl start php*-fpm.service \
	&& systemctl enable php*-fpm.service \
	&& systemctl stop nginx.service \
	&& systemctl start nginx.service \
	&& systemctl enable nginx.service \
	&& systemctl stop mariadb.service \
	&& systemctl start mariadb.service \
	&& systemctl enable mariadb.service

RUN mkdir -p /run/php/ \
	&& mkdir -p /config/
COPY startup.sh .
RUN chmod +x startup.sh
CMD ./startup.sh
#END of LEMP Build
