### Set Consul Agent ACL Tokens

# Set Consul ACL Policy Tokens
consul acl set-agent-token master $(echo $CONSUL_GLOBAL_MANAGEMENT_TOKEN)
consul acl set-agent-token agent $CONSUL_AGENT_TOKEN
consul acl set-agent-token default $CONSUL_AGENT_TOKEN


# Debugging
echo
echo "Consul Tokens..."
echo "  Step: Config ACL Tokens"
echo "    MGMT Token:     $CONSUL_GLOBAL_MANAGEMENT_TOKEN"
echo "    HTTP Token:     $CONSUL_HTTP_TOKEN"
echo "    Agent Response: $CONSUL_AGENT_RESPONSE"
echo "    Agent Token:    $CONSUL_AGENT_TOKEN"

