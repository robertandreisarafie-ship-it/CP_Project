#!/bin/bash
# Wait for Vault to be ready
sleep 5
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN='root-token'

# Store the secret — NO hardcoded secrets in app config files
vault kv put secret/myapp api_key="super-secret-api-key-$(openssl rand -hex 8)"
echo "✅ Secret written to Vault"