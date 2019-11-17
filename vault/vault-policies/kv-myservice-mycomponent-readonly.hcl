path "kv/metadata/*" {
   capabilities = ["list"]
}

path "kv/data/*" {
  capabilities = ["list"]
} 

path "kv/data/myService/*" {
   capabilities = ["read", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read"]
}

path "sys/mounts" {
  capabilities = [ "read" ]
}
