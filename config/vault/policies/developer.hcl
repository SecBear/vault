# Developer policy - Simplified with namespace isolation
# Developers have full access to their namespace and limited access to shared services

# Full access to developer namespace
path "developer/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Access to shared services in root namespace
# Transit encryption - allow usage but not configuration
path "transit/encrypt/*" {
  capabilities = ["create", "update"]
}
path "transit/decrypt/*" {
  capabilities = ["create", "update"]
}
path "transit/keys" {
  capabilities = ["list"]
}
path "transit/keys/*" {
  capabilities = ["read"]
}

# Read shared secrets in root namespace
path "secret/data/shared/*" {
  capabilities = ["read"]
}
path "secret/metadata/shared/*" {
  capabilities = ["list"]
}

# Ethereum plugin - allow key usage but not key management
path "ethereum/key-managers/+/txn/sign" {
  capabilities = ["create", "update"]
}
path "ethereum/key-managers/+/addresses" {
  capabilities = ["read"]
}
path "ethereum/key-managers" {
  capabilities = ["list"]
}

# PKI - Request client certificates only
path "pki/issue/client" {
  capabilities = ["create", "update"]
}

# Allow token renewal and lookup
path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Health check access
path "sys/health" {
  capabilities = ["read"]
}
