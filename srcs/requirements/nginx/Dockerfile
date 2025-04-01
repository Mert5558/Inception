FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y \
	nginx \
	openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/O=42HN/CN=${DOMAIN_NAME}"

COPY ./conf/default /etc/nginx/sites-available/.

RUN mkdir -p /run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]