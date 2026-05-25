#!/bin/bash
set -e

echo "🚀 Starting full deployment..."

# 1. Install Docker + Docker Compose if not present
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
fi

# 2. Bring up all services
docker compose up -d --build

# 3. Init Vault with the secret (runtime injection, not hardcoded)
docker exec vault sh -c "
  export VAULT_ADDR='http://127.0.0.1:8200'
  export VAULT_TOKEN='root-token'
  vault kv put secret/myapp api_key=\$(openssl rand -hex 16)
"

echo ""
echo "✅ Deployment complete!"
echo "   App via Nginx:  http://localhost"
echo "   Grafana:        http://localhost:3000"