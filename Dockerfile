FROM ubuntu:14.04

WORKDIR /root
ENV HOME /root

# install basic tools
RUN apt-get update && \
    apt-get install curl -y

# install mariadb anc clean default database
RUN echo 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu trusty main' > /etc/apt/sources.list.d/mariadb.list && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mariadb-server-10.0 mariadb-client-10.0 && \
    rm -rf /var/lib/mysql/*

# install templater
RUN curl -sL https://github.com/michaloo/templater/releases/download/v0.0.1/templater.tar.gz | \
    tar -xz -C /usr/local/bin

# add startup scripts and config files
ADD ./bin    /app/bin
ADD ./config /app/config

EXPOSE 3306

VOLUME [ "/var/lib/mysql", "/tmp" ]

ENTRYPOINT ["/app/bin/start"]

CMD []
