#!/bin/bash

set -e

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

cd /var/www/html
echo "11111111"
if [ -f ./wp-config.php ]
then
	echo "Wordpress already installed"
else
	echo "Waiting for MariaDB to be ready... (wp script.sh)"
	until mysql -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -e "SELECT 1;" > /dev/null 2>&1; do
		sleep 2
	done
	echo "Database is ready!"

	if [ ! -f /usr/local/bin/wp ]
	then
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		chmod +x wp-cli.phar
		mv wp-cli.phar /usr/local/bin/wp
	fi

	if [ ! -f ./index.php ]
	then
		wp core download --allow-root
	fi

	rm -f /var/www/html/index.nginx-debian.html

	wp config create \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_PASS" \
		--dbhost="$DB_HOST" \
		--allow-root
	
	wp core install \
		--url="$WP_URL" \
		--title="$WP_TITLE" \
		--admin_user="$ADMIN_USER" \
		--admin_password="$ADMIN_PASS" \
		--admin_email="$ADMIN_EMAIL" \
		--allow-root
	
	echo "hello im here"
	if ! wp user get "$WP_USER" --allow-root > /dev/null 2>&1
	then
		wp user create "$WP_USER" "$WP_USER_EMAIL" \
			--role=author --user_pass="$WP_USER_PASS" --allow-root
	fi

	chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F
