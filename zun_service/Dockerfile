#FROM ubuntu:16.04
FROM jpetazzo/dind
EXPOSE 9512
RUN apt-get update -y
RUN apt-get install mysql-client -y
RUN apt-get install python-mysqldb -y
RUN apt-get install vim -y

#Install docker
#RUN apt-get install apt-transport-https ca-certificates -y
#RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#RUN echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' >> /etc/apt/sources.list.d/docker.list
#RUN apt-get update -y
#RUN apt-get purge lxc-docker -y
#RUN apt-get install docker-engine -y
#RUN service docker start

COPY bin/zun_script.sh /
RUN mkdir -p /etc/zun
COPY config/* /etc/zun/
RUN chmod +x /zun_script.sh
RUN apt-get install -y libmysqlclient-dev build-essential python-dev \
                        git
RUN apt-get install python-pip -y
RUN mkdir -p /etc/zun
RUN mkdir -p /root/zun
RUN git clone https://git.openstack.org/openstack/zun /root/zun
WORKDIR /root/zun
RUN pip install -e .
RUN apt-get install crudini -y
RUN apt-get install python-openstackclient -y
WORKDIR /root
RUN git clone https://github.com/openstack/python-zunclient
WORKDIR /root/python-zunclient
RUN pip install -e .
CMD ["wrapdocker", "/zun_script.sh"]

