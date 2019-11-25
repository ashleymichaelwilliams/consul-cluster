### Start Vault Server

# Enable Vault Auto-Complete for CLI
vault -autocomplete-install

# Set Consul Agent Token
export CONSUL_HTTP_TOKEN=$CONSUL_AGENT_TOKEN

# Set Vault Connection Variable
echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.bashrc

# Start Vault Server Agent
vault server -config=/vault/vault-config/config.json &
