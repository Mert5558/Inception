#!/bin/bash

# Start MariaDB in background
mysqld &

# Wait until MariaDB is accepting connections
until mysqladmin ping -u root -p"${MYSQL_ROOT_PASSWORD}" --silent; do
	sleep 1
done

echo "MariaDB is ready."

# Try to create user + DB
echo "Creating database and user..."

mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL

echo "✅ User and DB created successfully."

# Keep MariaDB in foreground ----
wait
