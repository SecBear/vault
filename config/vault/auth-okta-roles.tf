# Okta OIDC Role Mappings
# Maps Okta groups to Vault policies

# Admin role - for vault-admins group
resource "vault_jwt_auth_backend_role" "admin" {
  backend        = vault_jwt_auth_backend.okta_oidc.path
  role_name      = "admin"
  token_policies = ["default", "admin"]

  allowed_redirect_uris = [
    "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback"
  ]

  user_claim   = "email"
  groups_claim = "groups"
  oidc_scopes  = ["openid", "email", "profile", "groups"]
  
  # Only users in vault-admins group can use this role
  bound_claims = {
    groups = "vault-admins"
  }
  
  token_ttl     = 3600
  token_max_ttl = 7200
}

# Developer role - for vault-developers group
resource "vault_jwt_auth_backend_role" "developer" {
  backend        = vault_jwt_auth_backend.okta_oidc.path
  role_name      = "developer"
  token_policies = ["default", "developer"]

  allowed_redirect_uris = [
    "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback"
  ]

  user_claim   = "email"
  groups_claim = "groups"
  oidc_scopes  = ["openid", "email", "profile", "groups"]
  
  bound_claims = {
    groups = "vault-developers"
  }
  
  token_ttl     = 3600
  token_max_ttl = 7200
}

# Operations role - for vault-operations group
resource "vault_jwt_auth_backend_role" "operations" {
  backend        = vault_jwt_auth_backend.okta_oidc.path
  role_name      = "operations"
  token_policies = ["default", "operations"]

  allowed_redirect_uris = [
    "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback"
  ]

  user_claim   = "email"
  groups_claim = "groups"
  oidc_scopes  = ["openid", "email", "profile", "groups"]
  
  bound_claims = {
    groups = "vault-operators"
  }
  
  token_ttl     = 3600
  token_max_ttl = 7200
}

# Audit viewer role - for vault-audit-viewers group
resource "vault_jwt_auth_backend_role" "audit_viewer" {
  backend        = vault_jwt_auth_backend.okta_oidc.path
  role_name      = "audit-viewer"
  token_policies = ["default", "audit-viewer"]

  allowed_redirect_uris = [
    "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback"
  ]

  user_claim   = "email"
  groups_claim = "groups"
  oidc_scopes  = ["openid", "email", "profile", "groups"]
  
  bound_claims = {
    groups = "vault-audit-viewers"
  }
  
  token_ttl     = 3600
  token_max_ttl = 7200
}

# External group aliases to automatically assign policies based on Okta groups
# This is an alternative approach using identity groups

# Create identity groups that map to policies
resource "vault_identity_group" "admins" {
  name     = "admins"
  type     = "external"
  policies = ["admin"]
}

resource "vault_identity_group" "developers" {
  name     = "developers"
  type     = "external"
  policies = ["developer"]
}

resource "vault_identity_group" "operations" {
  name     = "operations"
  type     = "external"
  policies = ["operations"]
}

resource "vault_identity_group" "audit_viewers" {
  name     = "audit-viewers"
  type     = "external"
  policies = ["audit-viewer"]
}

# Create group aliases that map Okta groups to Vault identity groups
resource "vault_identity_group_alias" "admins" {
  name           = "vault-admins"  # This should match the Okta group name
  mount_accessor = vault_jwt_auth_backend.okta_oidc.accessor
  canonical_id   = vault_identity_group.admins.id
}

resource "vault_identity_group_alias" "developers" {
  name           = "vault-developers"
  mount_accessor = vault_jwt_auth_backend.okta_oidc.accessor
  canonical_id   = vault_identity_group.developers.id
}

resource "vault_identity_group_alias" "operations" {
  name           = "vault-operators"
  mount_accessor = vault_jwt_auth_backend.okta_oidc.accessor
  canonical_id   = vault_identity_group.operations.id
}

resource "vault_identity_group_alias" "audit_viewers" {
  name           = "vault-audit-viewers"
  mount_accessor = vault_jwt_auth_backend.okta_oidc.accessor
  canonical_id   = vault_identity_group.audit_viewers.id
}