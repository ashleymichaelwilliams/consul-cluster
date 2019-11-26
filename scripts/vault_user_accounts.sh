### Create User Accounts

# Create Tara's User Account

# Create Vault Entity and Get Accessor
ENTITY=$(vault write identity/entity name="twilliams" policies="default" policies="kv-mysecret-limited" -format=json)
AUTH_ACCESSOR=$(vault auth list -format=json | jq -r '.["userpass/"].accessor')

# Set Password for Entity
vault write auth/userpass/users/twilliams password='harper123'

# Create Entity Alias
vault write identity/entity-alias name="twilliams" canonical_id=$(echo $ENTITY  | jq -r '.data.id') mount_accessor=$(echo $AUTH_ACCESSOR)



### Create Ashley's User Account

# Create Vault Entity and Get Accessor
ENTITY=$(vault write identity/entity name="awilliams" policies="default" policies="kv-mysecret-full" -format=json)
AUTH_ACCESSOR=$(vault auth list -format=json | jq -r '.["userpass/"].accessor')

# Set Password for Entity
vault write auth/userpass/users/awilliams password='pass1234'

# Create Entity Alias
vault write identity/entity-alias name="awilliams" canonical_id=$(echo $ENTITY  | jq -r '.data.id') mount_accessor=$(echo $AUTH_ACCESSOR)

