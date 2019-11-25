### Consul ACL Bootstrap

# Create Bootstrap Token for Consul Cluster
export CONSUL_BOOTSTRAP=$(curl -s --request PUT http://127.0.0.1:8500/v1/acl/bootstrap)
echo $CONSUL_BOOTSTRAP > /home/consul/.consul-bootstrap.json

# Store Consul Global Management Token
export CONSUL_GLOBAL_MANAGEMENT_TOKEN=$(echo $CONSUL_BOOTSTRAP | jq -r '.SecretID')
echo "export CONSUL_GLOBAL_MANAGEMENT_TOKEN=$CONSUL_GLOBAL_MANAGEMENT_TOKEN" >> ~/.bashrc

# Set Consul HTTP Token to the Global Management Token
export CONSUL_HTTP_TOKEN=$CONSUL_GLOBAL_MANAGEMENT_TOKEN
echo "export CONSUL_HTTP_TOKEN=$CONSUL_GLOBAL_MANAGEMENT_TOKEN" >> ~/.bashrc


# Debugging
echo
echo "Consul Tokens..."
echo "  Step: Create Bootstrap Token"
echo "    MGMT Token: $CONSUL_GLOBAL_MANAGEMENT_TOKEN"
echo "    HTTP Token: $CONSUL_HTTP_TOKEN"

