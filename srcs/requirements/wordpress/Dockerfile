FROM alpine:3.17.5

COPY tools/setupWordpressAndRunPhp.sh .

RUN apk update && \
	echo "y" | apk add --no-cache php php-fpm php-cgi php-mysqli php-phar php-curl \
	wget curl composer && \
	mkdir -p /var/www/html && \
	chmod +x setupWordpressAndRunPhp.sh && \
	adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

COPY conf/www.conf /etc/php81/php-fpm.d/www.conf

CMD ["./setupWordpressAndRunPhp.sh"]