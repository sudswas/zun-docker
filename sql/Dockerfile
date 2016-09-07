FROM ubuntu:14.04
EXPOSE 3306

RUN apt-get update -y
# Configure and install MySQL
RUN DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
ADD my.cnf /etc/mysql/conf.d/
COPY bin/sql_setups /
ENTRYPOINT ["/sql_setups"]
