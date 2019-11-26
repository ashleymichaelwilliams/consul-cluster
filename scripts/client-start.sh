### Consul-Template

# Set Consul Agent ACL Tokens
consul acl set-agent-token agent $CONSUL_AGENT_TOKEN
consul acl set-agent-token default $CONSUL_CLIENT_TOKEN

sleep 5

# Run Consul-Template
consul-template -template "/consul-template/config.tpl:/consul-template/config-values.yml" -once

