### Create MyService Vault Policy and Tokens

# Create Vault kv-myservice-mycomponent-readonly Policy File
cat /vault/vault-policies/kv-myservice-mycomponent-readonly.hcl | vault policy write kv-myservice-mycomponent-readonly -

# Create Client Auth Token
VAULT_CLIENT_REQUEST=$(vault token create -display-name='kv-myService-myComponent-ReadOnly' -policy='kv-myservice-mycomponent-readonly' -format=json)


# Get Client Auth Token
VAULT_CLIENT_AUTH_TOKEN=$(echo $VAULT_CLIENT_REQUEST | jq -r '.auth.client_token')

export VAULT_CLIENT_AUTH_TOKEN=$VAULT_CLIENT_AUTH_TOKEN
echo "export VAULT_CLIENT_AUTH_TOKEN=$VAULT_CLIENT_AUTH_TOKEN" >> ~/.bashrc


# Create Secret Keys
vault kv put kv/myService/myComponent/envs/dev pass='7h1$_1S_@_DEV_600d_P@55WoRd!@#'
vault kv put kv/myService/myComponent/envs/stg pass='7h1$_1S_@_STG_600d_P@55WoRd!@#'
vault kv put kv/myService/myComponent/envs/prod pass='7h1$_1S_@_PROD_600d_P@55WoRd!@#'


# Debugging
echo
echo "Consul Tokens..."
echo "  Step: Create MyService Policy and Token"
echo "    MGMT Token:       $CONSUL_GLOBAL_MANAGEMENT_TOKEN"
echo "    HTTP Token:       $CONSUL_HTTP_TOKEN"
#echo "    Agent Response:   $CONSUL_AGENT_RESPONSE"
echo "    Agent Token:      $CONSUL_AGENT_TOKEN"
echo "    Service Token:    $CONSUL_SERVICE_TOKEN"

# Debugging
echo
echo "Vault Tokens..."
echo "  Step: Create MyService Policy and Token"
echo "    Vault Root Token: $VAULT_ROOT_TOKEN"
echo "    Vault Token:      $VAULT_TOKEN"
#echo "    Client Response:  $VAULT_CLIENT_REQUEST"
echo "    Client Token:     $VAULT_CLIENT_AUTH_TOKEN"

