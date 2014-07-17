FROM ubuntu:14.04

WORKDIR /root
ENV HOME /root

# install basic tools
RUN apt-get update && \
    apt-get install curl sudo expect -y

# install mariadb
RUN echo 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu precise main' > /etc/apt/sources.list.d/mariadb.list && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mariadb-server-10.0 mariadb-client-10.0

# install templater
RUN cd /usr/local/bin && \
    curl -L https://github.com/michaloo/templater/releases/download/v0.0.1/templater.tar.gz | \
    tar -xzv

# add startup scripts and config files
ADD dev/bin    /app/bin
ADD dev/config /app/config

EXPOSE 3306

VOLUME ["/var/lib/mysql", "/var/log/mysql/", "/var/run/mysqld/", "/tmp"]

ENTRYPOINT ["/app/bin/before_mysql"]

CMD []
