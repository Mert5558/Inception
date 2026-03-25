#!/bin/bash
set -eu

mysql_esc() {
	printf "%s" "$1" | sed "s/'/''/g"
}

mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

MYSQL_ROOT_PASSWORD_ESC="$(mysql_esc "${MYSQL_ROOT_PASSWORD:-}")"
MYSQL_DATABASE_ESC="$(mysql_esc "${MYSQL_DATABASE:-}")"
MYSQL_USER_ESC="$(mysql_esc "${MYSQL_USER:-}")"
MYSQL_PASSWORD_ESC="$(mysql_esc "${MYSQL_PASSWORD:-}")"

if [ -z "${MYSQL_ROOT_PASSWORD_ESC}" ] || [ -z "${MYSQL_DATABASE_ESC}" ] || [ -z "${MYSQL_USER_ESC}" ] || [ -z "${MYSQL_PASSWORD_ESC}" ]; then
	echo "Missing required env vars: MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD"
	exit 1
fi

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "Initializing MariaDB data directory..."
	if command -v mariadb-install-db >/dev/null 2>&1; then
		mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
	else
		mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null
	fi
fi

cat > /tmp/init.sql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD_ESC}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE_ESC}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER_ESC}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_ESC}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE_ESC}\`.* TO '${MYSQL_USER_ESC}'@'%';
FLUSH PRIVILEGES;
EOF

chown mysql:mysql /tmp/init.sql
chmod 600 /tmp/init.sql

exec mysqld --user=mysql --socket=/run/mysqld/mysqld.sock --init-file=/tmp/init.sql
