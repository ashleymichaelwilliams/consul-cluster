#!/bin/bash

if [ "$1" = 'keygen' ]
then
  consul keygen


elif [ "$1" = 'server' ]
then
  cp /consul/config-templates/consul-server.json /consul/consul-config/

  consul agent \
    -config-dir=/consul/consul-config/ \
    -config-format=json \
    -bind='{{GetInterfaceIP "eth0"}}' \
    -node-meta="environment:$CUSTOM_ENV"


elif [ "$1" = 'server-encrypt' ]
then
  echo -E "{\"encrypt\": \"$2\"}" | jq '.'  > /consul/consul-config/.encrypt.key
  ENCRYPTION_KEY=$(cat /consul/consul-config/.encrypt.key | jq -r .encrypt)
  jq --arg key $ENCRYPTION_KEY '. += {"encrypt": $key}' /consul/config-templates/consul-server.json  | tee -a /consul/consul-config/consul-server.json

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


elif [ "$1" = 'client-encrypt' ]
then
  echo -E "{\"encrypt\": \"$2\"}" | jq '.'  > /consul/consul-config/.encrypt.key
  ENCRYPTION_KEY=$(cat /consul/consul-config/.encrypt.key | jq -r .encrypt)
  jq --arg key $ENCRYPTION_KEY '. += {"encrypt": $key}' /consul/config-templates/consul-client.json  | tee -a /consul/consul-config/consul-client.json

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


elif [ "$1" = 'redis-encrypt' ]
then
  echo -E "{\"encrypt\": \"$2\"}" | jq '.'  > /consul/consul-config/.encrypt.key
  ENCRYPTION_KEY=$(cat /consul/consul-config/.encrypt.key | jq -r .encrypt)
  jq --arg key $ENCRYPTION_KEY '. += {"encrypt": $key}' /consul/config-templates/consul-client.json  | tee -a /consul/consul-config/consul-client.json
  
  cp /consul/config-templates/redis-$ROLE.json /consul/consul-config/

  consul agent \
    -config-dir=/consul/consul-config/ \
    -config-format=json \
    -node-meta="environment:$CUSTOM_ENV"


else 
  echo 'Consul container was not provided a valid parameter!'
  echo "Valiate parameters are: 'keygen', 'agent[-encrypt]', 'client[-encrypt]' or 'redis[-encrypt]'"
  echo
  echo "Note: If parameter is set to 'redis', ensure you set the environment parameter \$ROLE to either 'primary' or 'secondary'"
  echo

fi
