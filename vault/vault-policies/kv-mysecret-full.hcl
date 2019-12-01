path "kv/metadata/*" {
   capabilities = ["list"]
}

path "kv/metadata/mySecret" {
   capabilities = ["create", "update", "delete", "read", "list"]
}

path "kv/data/mySecret" {
   capabilities = ["create", "update", "delete", "read", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read"]
}

path "sys/mounts" {
  capabilities = ["read"]
}
