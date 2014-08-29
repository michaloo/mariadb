michaloo/mariadb
=========

Simple mariadb docker image with startup scripts.

# Build or pull

`docker pull michaloo/mariadb`

`docker build -t michaloo/mariadb .`


# Setup

Environmental variables to set:

* MYSQL\_ROOT\_PASSWORD
* MYSQL\_DB (optional)
* MYSQL\_USER (optional, depends on MYSQL\_DB)
* MYSQL\_PASS (same as above)
* MYSQLD\_ARGS

# Conainer lifecycle

If `/var/lib/mysql/mysql` doesn't exists script executes `mysql_install_db`.

Then using `mysqld --bootstrap` it sets root password and tries to create database and user (specified via above variables).

Configuration options are supplied via `/etc/mysql/conf.d/my.cnf` file which is generated on every start using `/app/config/my.cnf` template (overriding it allows customization).

If image is run as an interactive, linked container (options: `-it --link mariadb:mysql --entrypoint=/bin/bash`) there is a useful script `/app/bin/connect` which executes `mysql` with data supplied via environmental variables (see below)

# Examples

For persistance create a storage container:

`docker run -d --name data_mysql_test -v /var/lib/mysql tianon/true`

Use it and provide environmental variables (using `.env` file)

`docker run -d --name mariadb -P --env-file .env --volumes-from data_mysql_test michaloo/mariadb`

Connect with it in an another container:

`docker run -it  --link mariadb:mysql --env-file .env --entrypoint=/bin/bash michaloo/mariadb /app/bin/connect`

