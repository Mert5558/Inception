#!/bin/bash

mysqld_safe --datadir=/var/lib/mysql &

# Wait for MariaDB to be ready
until mysqladmin ping -u root --silent; do
	echo "⏳ Waiting for MariaDB to be ready..."
	sleep 1
done

echo "✅ MariaDB is ready, initializing..."

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	mysql -u root <<-EOSQL
		-- Create remote root access
		CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

		-- Create WordPress database and user
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

		FLUSH PRIVILEGES;
EOSQL
	echo "✅ MariaDB setup completed."
else
	echo "✅ MariaDB already initialized."
fi

wait
