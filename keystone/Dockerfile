FROM ubuntu:16.04
EXPOSE 80 5000 35357
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update -y

#Install keystone
RUN apt-get install mysql-client -y
RUN apt-get install keystone -y
RUN apt-get install python-openstackclient -y
RUN apt-get install crudini -y

#Install RabbitMQ

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server && \
  rabbitmq-plugins enable rabbitmq_management && \
  echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config 
COPY bin/sql_scripts.sh /
#CMD rabbitmq-server && sql_scripts.sh
CMD ["/sql_scripts.sh"]

