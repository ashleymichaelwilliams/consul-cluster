path "kv/metadata/*" {
   capabilities = ["list"]
}

path "kv/metadata/mySecret" {
   capabilities = ["read", "list"]
}

path "kv/data/mySecret" {
   capabilities = ["create", "update", "read", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read"]
}

path "sys/mounts" {
  capabilities = ["read"]
}
