### Vault Initialization

VAULT_INIT=$(vault operator init -format=json)
echo $VAULT_INIT > /home/consul/.vault-init.json

vault operator unseal $(echo $VAULT_INIT | jq -r '.unseal_keys_hex[0]')
vault operator unseal $(echo $VAULT_INIT | jq -r '.unseal_keys_hex[1]')
vault operator unseal $(echo $VAULT_INIT | jq -r '.unseal_keys_hex[2]')


# Set Vault Token to Vault's Built-in Root Token
export VAULT_ROOT_TOKEN=$(echo $VAULT_INIT | jq -r '.root_token')
export VAULT_TOKEN=$VAULT_ROOT_TOKEN

echo "export VAULT_ROOT_TOKEN=$VAULT_ROOT_TOKEN" >> ~/.bashrc
echo "export VAULT_TOKEN=$VAULT_ROOT_TOKEN" >> ~/.bashrc

echo 
echo "Vault Tokens..."
echo "Vault Root Token: $VAULT_ROOT_TOKEN"
echo "Vault Token: $VAULT_TOKEN"
