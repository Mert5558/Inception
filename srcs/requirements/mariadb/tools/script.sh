#!/bin/bash
set -euo pipefail

SOCKET="/run/mysqld/mysqld.sock"
DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
	echo "[mariadb] Initializing database directory..."
	mariadb-install-db --user=mysql --datadir="$DATADIR" > /dev/null

	echo "[mariadb] Bootstrapping with temporary server..."
	mysqld --user=mysql --skip-networking --socket="$SOCKET" &
	pid="$!"

	until mysqladmin --socket="$SOCKET" ping --silent > /dev/null 2>&1; do
		sleep 1
	done

	mysql --socket="$SOCKET" -uroot <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

	mysqladmin --socket="$SOCKET" -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait "$pid" || true
fi

echo "[mariadb] Starting server..."
exec mysqld --user=mysql
