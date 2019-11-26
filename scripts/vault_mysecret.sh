### Create Sample Vault MySecret KV Policies and Key/Value

# Create Vault kv-mysecret-full Policy File
cat /vault/vault-policies/kv-mysecret-full.hcl | vault policy write kv-mysecret-full -

# Create Vault kv-mysecret-readonly Policy File
cat /vault/vault-policies/kv-mysecret-readonly.hcl | vault policy write kv-mysecret-readonly -

# Create Vault kv-mysecret-limited Policy File
cat /vault/vault-policies/kv-mysecret-limited.hcl | vault policy write kv-mysecret-limited -

# Create mySecret K/V
vault kv put kv/mySecret myKey='mySecret!123'

