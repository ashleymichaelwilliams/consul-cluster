#!/bin/bash

# Setup Server 1

docker run \
 --name consul-master-1 \
 -p 18500:8500 \
 -p 18600:8600/udp \
 -p 18200:8200 \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -d consul server


# Setup Server 2

docker run \
 --name consul-master-2 \
 -p 28500:8500 \
 -p 28600:8600/udp \
 -p 28200:8200 \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -d consul server


# Setup Server 3

docker run \
 --name consul-master-3 \
 -p 38500:8500 \
 -p 38600:8600/udp \
 -p 38200:8200 \
 --cap-add IPC_LOCK \
 --env-file dev.env \
 -d consul server


echo
echo -e "Now Preparing...\n1.) Bootstrap Consul Cluster\n2.) Configure Consul ACL Policies & Tokens\n3.) Start/Initialize Vault Service\n4.) Install Auth Methods and Secret Engines\n5.) Set Agent Tokens on remaining Consul Masters"
echo
echo "Allowing Consul Masters to Finish Clustering..."
sleep 15

docker exec -ti consul-master-1 bash -c "source /home/consul/scripts/consul_bootstrap.sh \
  && source /home/consul/scripts/consul_agents.sh \
  && source /home/consul/scripts/consul_set_acls.sh \
  && source /home/consul/scripts/consul_myservice.sh \
  && source /home/consul/scripts/consul_redis.sh \
  && source /home/consul/scripts/vault_start.sh \
  && sleep 10 \
  && source /home/consul/scripts/vault_init.sh \
  && source /home/consul/scripts/vault_enable_features.sh \
  && source /home/consul/scripts/vault_mysecret.sh \
  && source /home/consul/scripts/vault_user_accounts.sh \
  && source /home/consul/scripts/vault_myservice.sh"


echo
echo 'Setting Consul Agent Tokens on remaining Consul Masters...!'

# Store Tokens as Variables
EXT_CONSUL_AGENT_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_AGENT_TOKEN' ~/.bashrc | cut -d'=' -f2")
EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN=$(docker exec -t consul-master-1 bash -c "grep 'CONSUL_GLOBAL_MANAGEMENT_TOKEN' ~/.bashrc | cut -d'=' -f2")


# Clean Strings of Encoding
export EXT_CONSUL_AGENT_TOKEN=$(echo "${EXT_CONSUL_AGENT_TOKEN}" | tr -d \"\\r\")
export EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN=$(echo "${EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN}" | tr -d \"\\r\")

echo
echo "Setting Consul Agent Tokens on Consul-Master-2"
docker exec -ti -e "CONSUL_HTTP_TOKEN=$EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN" consul-master-2 bash -c "sleep 5 \
  && consul acl set-agent-token master $(echo $EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN) \
  && consul acl set-agent-token agent $(echo $EXT_CONSUL_AGENT_TOKEN) \
  && consul acl set-agent-token default $(echo $EXT_CONSUL_AGENT_TOKEN)"

echo
echo "Setting Consul Agent Tokens on Consul-Master-3"
docker exec -ti -e "CONSUL_HTTP_TOKEN=$EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN" consul-master-3 bash -c "sleep 5 \
  && consul acl set-agent-token master $(echo $EXT_CONSUL_GLOBAL_MANAGEMENT_TOKEN) \
  && consul acl set-agent-token agent $(echo $EXT_CONSUL_AGENT_TOKEN) \
  && consul acl set-agent-token default $(echo $EXT_CONSUL_AGENT_TOKEN)"


echo
echo 'Finished Installing, Configuring and Initializing Hashicorp Consul and Vault services...!'
sleep 3

echo
echo "Openning Web UIs for Consul Masters..."

# Open Consul Web UI
open http://localhost:18500/ui/ http://localhost:28500/ui/ http://localhost:38500/ui/

echo "Openning Web UIs for Vault Servers..."

# Open Vault Web UI
open http://localhost:18200/ui/

echo
