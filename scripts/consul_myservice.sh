### MyService ACL Policy/Token

# Create Consul ACL Policy for MyService
consul acl policy create -name=myservice-read -rules=@/consul/consul-policies/myservice-read.json

# Create Consul Token for MyService
CONSUL_SERVICE_TOKEN=$(curl -s -X PUT \
  --header "Authorization: Bearer $CONSUL_HTTP_TOKEN" \
  --data \
'{
   "Description": "myService Token",
   "Policies": [
      {
         "Name": "myservice-read"
      }
   ],
   "Local": false
}' http://127.0.0.1:8500/v1/acl/token)

export CONSUL_SERVICE_TOKEN=$(echo $CONSUL_SERVICE_TOKEN | jq -r '.SecretID')
echo "export CONSUL_SERVICE_TOKEN=$CONSUL_SERVICE_TOKEN" >> ~/.bashrc


# Debugging
echo
echo "Consul Tokens..."
echo "  Step: Create MyService Policy and Token"
echo "    MGMT Token:      $CONSUL_GLOBAL_MANAGEMENT_TOKEN"
echo "    HTTP Token:      $CONSUL_HTTP_TOKEN"
#echo "    Agent Response:  $CONSUL_AGENT_RESPONSE"
echo "    Agent Token:     $CONSUL_AGENT_TOKEN"
echo "    Service Token:   $CONSUL_SERVICE_TOKEN"



# Create Test K/V Structure
export ENV="dev"
consul kv put myService/myComponent/envs/$ENV/max_conns "32768"
consul kv put myService/myComponent/envs/$ENV/fs.file-max "524288"

export ENV="stg"
consul kv put myService/myComponent/envs/$ENV/max_conns "250000"
consul kv put myService/myComponent/envs/$ENV/fs.file-max "1048576"

export ENV="prod"
consul kv put myService/myComponent/envs/$ENV/max_conns "500000"
consul kv put myService/myComponent/envs/$ENV/fs.file-max "2097152"

