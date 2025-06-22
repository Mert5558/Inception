FROM debian:bullseye

RUN apt update && apt install -y mariadb-server mariadb-client \
    && apt clean

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/script.sh /script.sh

RUN chmod +x /script.sh && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

EXPOSE 3306

CMD ["/script.sh"]
