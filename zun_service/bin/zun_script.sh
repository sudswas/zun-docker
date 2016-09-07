#!/bin/bash
zun_password=${ZUN_PASSWORD:-password}

mysql -uroot  -h mysql -e "CREATE DATABASE IF NOT EXISTS zun DEFAULT CHARACTER SET utf8"
mysql -uroot  -h mysql -e "GRANT ALL PRIVILEGES ON zun.* TO 'zun'@'%' IDENTIFIED BY '$zun_password'"
crudini --set /etc/zun/zun.conf keystone_authtoken auth_uri http://controller/v2.0/v3
crudini --set /etc/zun/zun.conf keystone_authtoken identity_uri http://controller:35357
crudini --set /etc/zun/zun.conf keystone_authtoken admin_tenant_name admin
crudini --set /etc/zun/zun.conf keystone_authtoken admin_user admin
crudini --set /etc/zun/zun.conf keystone_authtoken admin_password password
sed -i "s/#rabbit_userid\s*=.*/rabbit_userid=guest/" /etc/zun/zun.conf
sed -i "s/#rabbit_password\s*=.*/rabbit_password=guest/" /etc/zun/zun.conf
sed -i "s/#connection\s*=.*/connection=mysql:\/\/zun:$zun_password@mysql\/zun/" /etc/zun/zun.conf
cd /root/zun/
zun-db-manage upgrade
export OS_URL=http://controller:35357/v2.0
export OS_TOKEN=ADMIN
#openstack service create --name=zun \
#                          --description="Zun Container Service" \
#                          container
#openstack endpoint create --publicurl http://127.0.0.1:9512/v1 \
#                          --adminurl http://127.0.0.1:9512/v1 \
#                          --internalurl http://127.0.0.1:9512/v1 \
#                          --region=RegionOne \
#                          container
print "We are here"
mkdir /var/log/zun
touch /var/log/zun/zun-api.log
touch /var/log/zun/zun-compute.log
zun-api --log-file=/var/log/zun/zun-api.log --config-file=/etc/zun/zun.conf &
zun-compute --log-file=/var/log/zun/zun-compute.log --config-file=/etc/zun/zun.conf

