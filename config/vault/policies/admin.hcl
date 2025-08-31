# Admin policy - Simplified with namespace isolation
# Admins have full access to their namespace and can manage infrastructure

# Full access to admin namespace
path "admin/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Full access to all team namespaces (can help troubleshoot)
path "operations/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "developer/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage all shared services in root namespace
path "transit/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "pki/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# System administration (with restrictions)
# Most system operations with sudo
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# EXPLICIT DENIES - Cannot perform root-only operations
# Deny root token generation
path "sys/generate-root/*" {
  capabilities = ["deny"]
}

# Deny raw storage access
path "sys/raw/*" {
  capabilities = ["deny"]
}

# Deny recovery operations
path "sys/recovery-keys/*" {
  capabilities = ["deny"]
}

# Auth management
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Deny root token creation (but allow all other token operations)
path "auth/token/create" {
  capabilities = ["create", "update", "sudo"]
  denied_parameters = {
    "policies" = ["root"]
  }
}

path "auth/token/create-orphan" {
  capabilities = ["create", "update", "sudo"]
  denied_parameters = {
    "policies" = ["root"]
  }
}

# Manage policies except root
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policies/acl/root" {
  capabilities = ["read"]  # Can read but not modify root policy
}

# Namespace management
path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Identity and entity management
path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Audit configuration
path "sys/audit/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Plugin catalog management - register/deregister plugins
path "sys/plugins/catalog/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List all plugins
path "sys/plugins/catalog" {
  capabilities = ["read", "list"]
}

# Reload plugins (when updating)
path "sys/plugins/reload/*" {
  capabilities = ["create", "update", "sudo"]
}

# Health and status
path "sys/health" {
  capabilities = ["read"]
}
path "sys/leader" {
  capabilities = ["read"]
}
path "sys/seal-status" {
  capabilities = ["read"]
}

# Token management (broad permissions for Terraform provider)
path "auth/token/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}