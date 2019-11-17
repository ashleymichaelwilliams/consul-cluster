#!/bin/bash

if [ "$1" = 'server' ]
then
  cp /consul/config-templates/consul-server.json /consul/consul-config/

  consul agent \
    -config-dir=/consul/consul-config/ \
    -config-format=json \
    -bind='{{GetInterfaceIP "eth0"}}' \
    -node-meta="environment:$CUSTOM_ENV"


elif [ "$1" = 'client' ]
then
  cp /consul/config-templates/consul-client.json /consul/consul-config/

  consul agent \
    -config-dir=/consul/consul-config/ \
    -config-format=json \
    -node-meta="environment:$CUSTOM_ENV"


elif [ "$1" = 'redis' ]
then
  cp /consul/config-templates/consul-client.json /consul/consul-config/
  cp /consul/config-templates/redis-$ROLE.json /consul/consul-config/

  consul agent \
    -config-dir=/consul/consul-config/ \
    -config-format=json \
    -node-meta="environment:$CUSTOM_ENV"


else 
  echo 'Consul container was not provided a valid parameter!'
  echo "Valiate parameters are: 'agent', 'client' or 'redis'"
  echo
  echo "Note: If parameter is set to 'redis', ensure you set the environment parameter \$ROLE to either 'primary' or 'secondary'"
  echo

fi
