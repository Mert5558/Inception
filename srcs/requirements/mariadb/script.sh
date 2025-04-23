#!/bin/bash

mysql_install_db
mysqld

# service mariadb start

# while ! mysqladmin ping --silent; do
# 	sleep 1
# done

# mysql -u root <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF

# service mariadb stop

# exec mysqld_safe
