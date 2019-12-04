#!/bin/bash

# Store Tokens as Variables
KEYGEN=$(docker exec -ti consul-master-1 bash -c "cat /consul/consul-data/serf/local.keyring  | jq -r  '.[]'")

EXT_CONSUL_AGENT_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_AGENT_TOKEN' ~/.bashrc | cut -d'=' -f2")
EXT_CONSUL_SERVICE_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_SERVICE_TOKEN' ~/.bashrc | cut -d'=' -f2")
EXT_CONSUL_REDIS_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_REDIS_TOKEN' ~/.bashrc | cut -d'=' -f2")
EXT_VAULT_CLIENT_AUTH_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'VAULT_CLIENT_AUTH_TOKEN' ~/.bashrc | cut -d'=' -f2")

# Clean Strings of Encoding
export KEYGEN=$(echo "${KEYGEN}" | tr -d \"\\r\")

export EXT_CONSUL_AGENT_TOKEN=$(echo "${EXT_CONSUL_AGENT_TOKEN}" | tr -d \"\\r\")
export EXT_CONSUL_SERVICE_TOKEN=$(echo "${EXT_CONSUL_SERVICE_TOKEN}" | tr -d \"\\r\")
export EXT_CONSUL_REDIS_TOKEN=$(echo "${EXT_CONSUL_REDIS_TOKEN}" | tr -d \"\\r\")
export EXT_VAULT_CLIENT_AUTH_TOKEN=$(echo "${EXT_VAULT_CLIENT_AUTH_TOKEN}" | tr -d \"\\r\")

echo
echo "Consul Encryption Key: $KEYGEN"
echo


echo 'Starting Docker Containers!'

### Setup Client 1

docker run \
 --name consul-client-1 \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -e CONSUL_HTTP_TOKEN="$EXT_CONSUL_AGENT_TOKEN" \
 -e CONSUL_AGENT_TOKEN="$EXT_CONSUL_AGENT_TOKEN" \
 -e CONSUL_CLIENT_TOKEN="$EXT_CONSUL_SERVICE_TOKEN" \
 -e VAULT_TOKEN="$EXT_VAULT_CLIENT_AUTH_TOKEN" \
 -e VAULT_ADDR="http://172.17.0.2:8200" \
 -d consul client-encrypt "$KEYGEN"


### Setup Redis Primary

docker run \
 --name consul-redis-primary \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -e CONSUL_HTTP_TOKEN="$EXT_CONSUL_AGENT_TOKEN" \
 -e CONSUL_AGENT_TOKEN="$EXT_CONSUL_AGENT_TOKEN" \
 -e CONSUL_REDIS_TOKEN="$EXT_CONSUL_REDIS_TOKEN" \
 -e VAULT_TOKEN="$EXT_VAULT_CLIENT_AUTH_TOKEN" \
 -e VAULT_ADDR="http://172.17.0.2:8200" \
 -e "ROLE=primary" \
 -d consul redis-encrypt "$KEYGEN"


### Setup Redis Secondary

docker run \
 --name consul-redis-secondary \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -e CONSUL_HTTP_TOKEN="$EXT_CONSUL_AGENT_TOKEN" \
 -e CONSUL_AGENT_TOKEN="$EXT_CONSUL_AGENT_TOKEN" \
 -e CONSUL_REDIS_TOKEN="$EXT_CONSUL_REDIS_TOKEN" \
 -e VAULT_TOKEN="$EXT_VAULT_CLIENT_AUTH_TOKEN" \
 -e VAULT_ADDR="http://172.17.0.2:8200" \
 -e "ROLE=secondary" \
 -d consul redis-encrypt "$KEYGEN"


echo
echo -e "Now Preparing...\n1.) Set Consul Agent Tokens on Consul-Template\n2.) Set Consul Agent Tokens on Redis Primary\n3.) Set Consul Agent Tokens on Redis Secondary"

echo
echo 'Setting Consul Agent Tokens on Consul Clients...!'
sleep 10

echo
echo "Setting Consul Agent Tokens on Consul-Client-1"
docker exec -ti consul-client-1 bash -c "source /home/consul/scripts/client-start.sh"

echo
echo "Setting Consul Agent Tokens on Consul-Redis-Primary"
docker exec -ti consul-redis-primary bash -c "source /home/consul/scripts/redis-start.sh"

echo
echo "Setting Consul Agent Tokens on Consul-Redis-Secondary"
docker exec -ti consul-redis-secondary bash -c "source /home/consul/scripts/redis-start.sh"


echo
echo 'Finished Configuring Consul Clients...!'

echo
