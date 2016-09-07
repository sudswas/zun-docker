#!/bin/bash

keystone_password=${KEYSTONE_PASSWORD:-password}
admin_token=${ADMIN_TOKEN:-ADMIN}
admin_password=${ADMIN_TENANT_PASSWORD:-password}
crudini --set /etc/keystone/keystone.conf database connection mysql://keystone:$keystone_password@mysql/keystone
crudini --set /etc/keystone/keystone.conf \
        DEFAULT \
        driver \
        keystone.identity.backends.sql.Identity
crudini --set /etc/keystone/keystone.conf \
        DEFAULT \
        idle_timeout \
        200
crudini --set /etc/keystone/keystone.conf \
        DEFAULT \
        admin_token \
        $admin_token
crudini --del /etc/keystone/keystone.conf \
        DEFAULT \
        log_file
crudini --set /etc/keystone/keystone.conf \
        signing \
        certfile \
        /srv/keystone/ssl/certs/signing_cert.pem
crudini --set /etc/keystone/keystone.conf \
        signing \
        keyfile \
        /srv/keystone/ssl/private/signing_key.pem
crudini --set /etc/keystone/keystone.conf \
        signing \
        ca_certs \
        /srv/keystone/ssl/certs/ca.pem
crudini --set /etc/keystone/keystone.conf \
        signing \
        ca_key \
        /srv/keystone/ssl/private/cakey.pem
service rabbitmq-server start
/bin/sh -c "keystone-manage db_sync" keystone
keystone-all --config-file=/etc/keystone/keystone.conf --log-file=/var/log/keystone/keystone.log &
sleep 10
rm -f /var/lib/keystone/keystone.db
#Let's create a keystone user to access the openstackclient from CMDLine

export OS_TOKEN=$admin_token
export OS_URL=http://controller:35357/v2.0

openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create \
  --publicurl http://controller:5000/v2.0 \
  --internalurl http://controller:5000/v2.0 \
  --adminurl http://controller:35357/v2.0 \
  --region RegionOne \
  identity

echo "Created the Identity service"

openstack project create --description "Admin Project" admin

openstack user create --password $admin_password admin

openstack role create admin

openstack role add --project admin --user admin admin

openstack project create --description "Service Project" service

openstack project create --description "Demo Project" demo

openstack user create --password $admin_password demo

openstack role create user

openstack role add --project demo --user demo user

echo "Created everything!"
bash
