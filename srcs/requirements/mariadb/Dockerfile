FROM alpine:3.17.5

RUN apk update && \
	echo "y" | apk add --no-cache mariadb mariadb-client

EXPOSE 3306

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY tools/initDatabase.sh .

RUN chmod 644 /etc/my.cnf.d/mariadb-server.cnf && \
	/bin/sh initDatabase.sh

COPY tools/runDatabase.sh .

RUN chmod +x runDatabase.sh

CMD ["./runDatabase.sh"]