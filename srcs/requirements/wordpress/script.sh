#!/bin/bash

set -e

if [ -f "/var/www/html/.env" ]
then
	set -a
	source /var/www/html/.env
	set +a
else
	echo ".env file not found! Exiting..."
	exit 1
fi

DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
DB_PASS="${MYSQL_PASSWORD}"
DB_HOST="${MYSQL_HOST}"

WP_URL="${WP_URL:-https://$DOMAIN_NAME}"
WP_TITLE="${WP_TITLE:-Inception}"

ADMIN_USER="${WP_ADMIN_USER}"
ADMIN_PASS="${WP_ADMIN_PASS}"
ADMIN_EMAIL="${WP_ADMIN_EMAIL}"

WP_USER="${WP_USER}"
WP_USER_PASS="${WP_USER_PASSWORD}"
WP_USER_EMAIL="${WP_USER_EMAIL}"

if [ -f ./wp-config.php ]
then
	echo "Wordpress already installed"
else
	cd /var/www/html

	echo "Waiting for MariaDB to be ready..."
	until mysqladmin ping -h"$DB_HOST" --silent; do
		sleep 2
	done
	echo "Database is ready!"

	if [ ! -f /usr/local/bin/wp ]
	then
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		chmod +x wp-cli.phar
		mv wp-cli.phar /usr/local/bin/wp
	fi

	./wp-cli.phar core download --allow-root

	./wp-cli.phar config create \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_PASS" \
		--dbhost="$DB_HOST" \
		--allow-root
	
	./wp-cli.phar core install \
		--url="$WP_URL" \
		--title="$WP_TITLE" \
		--admin_user="$ADMIN_USER" \
		--admin_password="$ADMIN_PASS" \
		--admin_email="$ADMIN_EMAIL" \
		--allow-root
	
	if ! ./wp-cli.phar user get "$WP_USER" --allow-root > /dev/null 2>&1
	then
		./wp-cli.phar user create "$WP_USER" "$WP_USER_EMAIL" \
			--role=author --user_pass="$WP_USER_PASS" --allow-root
	fi

	chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F



# if [ -f ./wp-config.php ]
# then
# 	echo "wordpress already downloaded"
# else

# 	cd /var/www/html
# 	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# 	chmod +x wp-cli.phar
# 	./wp-cli.phar core download --allow-root
# 	./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
# 	./wp-cli.phar core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

# 	php-fpm8.2 -F

# fi