# groups to map to vault policies - managed as resources
resource "okta_group" "vault-admins" {
  name        = "vault-admins"
  description = "Vault administrators with full system access"
}

resource "okta_group" "vault-developers" {
  name        = "vault-developers"
  description = "Vault developers with access to developer namespace"
}

resource "okta_group" "vault-operators" {
  name        = "vault-operators"
  description = "Vault operators with infrastructure management access"
}

resource "okta_group" "vault-audit-viewers" {
  name        = "vault-audit-viewers"
  description = "Users with read-only access to Vault audit logs"
}

# vault oauth application
resource "okta_app_oauth" "vault_oidc" {
  label       = "Vault"
  type        = "web"
  grant_types = ["authorization_code"]
  redirect_uris = [
    "http://localhost:8200/authorization-code/callback",
    "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback",
  ]
  post_logout_redirect_uris = ["http://localhost:8200"]
  consent_method            = "REQUIRED"
  implicit_assignment       = true
  issuer_mode               = "DYNAMIC"
  omit_secret               = true
  response_types            = ["code"]

  # Ignore refresh token settings since we don't use refresh tokens
  lifecycle {
    ignore_changes = [
      refresh_token_leeway,
      refresh_token_rotation
    ]
  }
}

