# FROM debian:bookworm

# RUN apt update && apt upgrade -y && apt install -y \
# 	php-fpm \
# 	php-mysqli \
# 	curl

# COPY www.conf /etc/php/8.2/fpm/pool.d/.
# COPY script.sh .
# RUN chmod +x script.sh

# EXPOSE 9000

# CMD ["./script.sh"]


FROM debian:bookworm

# Install required packages
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
	mariadb-client \
	curl \
	wget \
	unzip \
	&& apt clean

# Set working directory
WORKDIR /var/www/html

# Copy configuration file for PHP
COPY www.conf /etc/php/8.2/fpm/pool.d/.

# Install WP-CLI globally
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Copy script and make it executable
COPY script.sh /script.sh
RUN chmod +x /script.sh

# Expose PHP-FPM port
EXPOSE 9000

# Run the setup script
CMD ["bash", "/script.sh"]
