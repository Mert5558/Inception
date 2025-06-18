FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	php-fpm \
	php-mysqli \
	php-curl \
	php-gd \
	php-mbstring \
	php-xml \
	php-xmlrpc \
	php-soap \
	php-intl \
	php-zip \
	#mariadb-client \
	curl \
	wget \
	unzip \
	&& apt clean

WORKDIR /var/www/html

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/.

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

RUN mkdir -p /run/php

EXPOSE 9000

CMD ["/script.sh"]
