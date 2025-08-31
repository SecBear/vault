# Audit viewer policy - For compliance and security teams
# Can view audit configuration but cannot modify

# Read audit device configuration
path "sys/audit" {
  capabilities = ["read", "list"]
}

# Read specific audit device config
path "sys/audit/*" {
  capabilities = ["read"]
}

# Create audit hash to verify entries
path "sys/audit-hash/*" {
  capabilities = ["create", "update"]
}

# View audit configuration settings
path "sys/config/auditing/*" {
  capabilities = ["read", "list"]
}

# Health and status checks
path "sys/health" {
  capabilities = ["read"]
}

path "sys/seal-status" {
  capabilities = ["read"]
}