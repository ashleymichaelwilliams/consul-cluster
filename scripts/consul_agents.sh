### Consul Agent Policies

# Create Consul ACL Policy (consul-masters-write and vault-write)
consul acl policy create -name=consul-masters-write -rules=@/consul/consul-policies/consul-masters-write.hcl

# Create Policy for Vault
consul acl policy create -name=vault-write -rules=@/consul/consul-policies/vault-write.json

# Create Consul Token for Consul Agents (as well as Vault service)
CONSUL_AGENT_RESPONSE=$(curl -s -X PUT \
  --header "Authorization: Bearer $CONSUL_HTTP_TOKEN" \
  --data \
'{
   "Description": "Consul Masters and Vault",
   "Policies": [
      {
         "Name": "vault-write"
      },
      {
         "Name": "consul-masters-write"
      }
   ],
   "Local": false
}' http://127.0.0.1:8500/v1/acl/token)


# Store Consul Agent Token
export CONSUL_AGENT_TOKEN=$(echo $CONSUL_AGENT_RESPONSE | jq -r '.SecretID')
echo "export CONSUL_AGENT_TOKEN=$CONSUL_AGENT_TOKEN" >> ~/.bashrc


# Debugging
echo
echo "Consul Tokens..."
echo "  Step: Create Agent Policy and Token"
echo "    MGMT Token:      $CONSUL_GLOBAL_MANAGEMENT_TOKEN"
echo "    HTTP Token:      $CONSUL_HTTP_TOKEN"
echo "    Agent Response:  $CONSUL_AGENT_RESPONSE"
echo "    Agent Token:     $CONSUL_AGENT_TOKEN"
