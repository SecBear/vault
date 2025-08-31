# Ethereum application policy - specific access for Ethereum operations
# This policy is for applications/services that need to sign Ethereum transactions

# Read-only access to specific key managers
path "ethereum/key-managers/deployer" {
  capabilities = ["read"]
}

path "ethereum/key-managers/deployer/addresses" {
  capabilities = ["read"]
}

# Transaction signing for specific addresses
path "ethereum/key-managers/deployer/txn/sign" {
  capabilities = ["create", "update"]
}

# List available key managers (but not create new ones)
path "ethereum/key-managers" {
  capabilities = ["list"]
}

# Token self-management
path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}