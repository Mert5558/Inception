FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	mariadb-server && \
	mkdir /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/script.sh .

RUN chmod +x script.sh

EXPOSE 3306

CMD ["/script.sh"]