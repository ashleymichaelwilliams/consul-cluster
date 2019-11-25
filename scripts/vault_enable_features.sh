### Enable Auth and Secret Engines

# Enable UserPass Auth Method
vault auth enable -path=userpass userpass


# Enable kv (Version 2) Secret Engine
vault secrets enable  -version=2 -path=kv kv
