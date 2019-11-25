
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


echo -e "Now Preparing...\n1.) Bootstrap Consul Cluster\n2.) Configure Consul ACL Policies & Tokens\n3.) Start/Initialize Vault Service\n4.) Install Auth Methods and Secret Engines..."
echo
echo "Allowing Consul Masters to Finish Clustering..."
sleep 10

docker exec -ti consul-master-1 bash -c "source /home/consul/scripts/consul_bootstrap.sh \
  && source /home/consul/scripts/consul_agents.sh \
  && source /home/consul/scripts/consul_set_acls.sh \
  && source /home/consul/scripts/consul_myservice.sh \
  && source /home/consul/scripts/vault_start.sh \
  && sleep 5 \
  && source /home/consul/scripts/vault_init.sh \
  && source /home/consul/scripts/vault_enable_features.sh"


echo
echo 'Finished Installing, Configuring and Initializing Hashicorp Consul and Vault services...!'


