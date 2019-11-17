path "kv/metadata/*" {
   capabilities = ["list"]
}

path "kv/metadata/mySecret" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/mySecret" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read"]
}

path "sys/mounts" {
  capabilities = ["read"]
}
