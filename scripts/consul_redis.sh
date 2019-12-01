### Redis ACL Policy/Token

# Create Consul ACL Policy for Redis
consul acl policy create -name=service-redis-write -rules=@/consul/consul-policies/service-redis-write.hcl

# Create Consul Token for Redis
CONSUL_REDIS_TOKEN=$(curl -s -X PUT \
  --header "Authorization: Bearer $CONSUL_HTTP_TOKEN" \
  --data \
'{
   "Description": "Redis Token",
   "Policies": [
      {
         "Name": "service-redis-write"
      }
   ],
   "Local": false
}' http://127.0.0.1:8500/v1/acl/token)

export CONSUL_REDIS_TOKEN=$(echo $CONSUL_REDIS_TOKEN | jq -r '.SecretID')
echo "export CONSUL_REDIS_TOKEN=$CONSUL_REDIS_TOKEN" >> ~/.bashrc


# Debugging
echo
echo "Consul Tokens..."
echo "  Step: Create MyService Policy and Token"
echo "    MGMT Token:      $CONSUL_GLOBAL_MANAGEMENT_TOKEN"
echo "    HTTP Token:      $CONSUL_HTTP_TOKEN"
#echo "    Agent Response:  $CONSUL_AGENT_RESPONSE"
echo "    Agent Token:     $CONSUL_AGENT_TOKEN"
echo "    Service Token:   $CONSUL_SERVICE_TOKEN"
echo "    Redis Token:     $CONSUL_REDIS_TOKEN"
