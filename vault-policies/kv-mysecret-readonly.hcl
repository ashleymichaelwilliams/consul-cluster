path "kv/metadata/*" {
   capabilities = ["list"]
}

path "kv/metadata/mySecret" {
   capabilities = ["read", "list"]
}

path "kv/data/mySecret" {
   capabilities = ["read", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read"]
}

path "sys/mounts" {
  capabilities = ["read"]
}
