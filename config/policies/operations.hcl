# Operations policy - Simplified with namespace isolation
# Operations team manages their namespace and limited infrastructure tasks

# Full access to operations namespace
path "operations/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Access to shared services in root namespace
# Transit encryption
path "transit/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage shared secrets
path "secret/data/shared/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "secret/metadata/shared/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# PKI - Issue and manage certificates
path "pki/*" {
  capabilities = ["create", "read", "update", "list"]
}

# View system health and status
path "sys/health" {
  capabilities = ["read"]
}
path "sys/leader" {
  capabilities = ["read"]
}
path "sys/seal-status" {
  capabilities = ["read"]
}

# Manage leases
path "sys/leases/*" {
  capabilities = ["read", "update", "list"]
}

# View audit configuration (but not modify)
path "sys/audit" {
  capabilities = ["read", "list"]
}

# Token management for self
path "auth/token/renew-self" {
  capabilities = ["update"]
}
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Create tokens for developers and themselves
path "auth/token/create" {
  capabilities = ["create", "update"]
  allowed_parameters = {
    "policies" = ["developer", "operations"]
    "ttl"      = ["1h", "2h", "4h", "8h", "24h"]
    "max_ttl"  = ["48h"]
  }
}