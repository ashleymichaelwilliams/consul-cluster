
# Store Tokens as Variables
EXT_CONSUL_AGENT_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_AGENT_TOKEN' ~/.bashrc | cut -d'=' -f2")
EXT_CONSUL_SERVICE_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_SERVICE_TOKEN' ~/.bashrc | cut -d'=' -f2")
EXT_VAULT_CLIENT_AUTH_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'VAULT_CLIENT_AUTH_TOKEN' ~/.bashrc | cut -d'=' -f2")

export EXT_CONSUL_AGENT_TOKEN=$(echo "${EXT_CONSUL_AGENT_TOKEN}" | tr -d \"\\r\")
export EXT_CONSUL_SERVICE_TOKEN=$(echo "${EXT_CONSUL_SERVICE_TOKEN}" | tr -d \"\\r\")
export EXT_VAULT_CLIENT_AUTH_TOKEN=$(echo "${EXT_VAULT_CLIENT_AUTH_TOKEN}" | tr -d \"\\r\")



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
 -d consul client


### Setup Redis Primary

docker run \
 --name consul-redis-primary \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -e "ROLE=primary" \
 -d consul redis


### Setup Redis Secondary

docker run \
 --name consul-redis-secondary \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -e "ROLE=secondary" \
 -d consul redis


echo
echo -e "Now Preparing...\n1.) Some Task"
echo
echo "Configuring Consul Clients..."
sleep 10

docker exec -ti consul-client-1 bash -c "source /home/consul/scripts/client-start.sh"


echo
echo 'Finished Configuring Consul Clients...!'

