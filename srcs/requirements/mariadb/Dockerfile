FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y \
	mariadb-server && \
	mkdir /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY init.sql /etc/mysql/init.sql
COPY script.sh .

RUN chmod +x script.sh

EXPOSE 3306

CMD ["./script.sh"]