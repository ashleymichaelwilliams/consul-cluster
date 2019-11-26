### Redis Startup Script: Service Discovery

# Set Consul Agent ACL Tokens
consul acl set-agent-token agent $CONSUL_AGENT_TOKEN
consul acl set-agent-token default $CONSUL_REDIS_TOKEN


