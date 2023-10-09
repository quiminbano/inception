FROM alpine:3.17.5

LABEL version=1.0

RUN apk update && \
	echo "y" | apk add --no-cache nginx && \
	echo "y" | apk add --no-cache openssl && \
	mkdir -p /etc/nginx/ssl/ && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/certificate.key \
    -out /etc/nginx/ssl/certificate.crt \
    -subj "/C=FI/ST=Helsinki/L=Helsiniki/O=Hive/OU=corellan/CN=corellan/" && \
	adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
