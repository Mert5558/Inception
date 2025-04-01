FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y \
	php-fpm \
	php-mysqli \
	curl

COPY www.conf /etc/php/8.2/fpm/pool.d/.
COPY script.sh .
RUN chmod +x script.sh

EXPOSE 9000

CMD ["./script.sh"]
