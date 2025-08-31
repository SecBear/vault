# TODO: change this to OKTA
# SOPS Data Source for encrypted secrets
data "sops_file" "oidc_secrets" {
  source_file = "okta-secrets.sops.yaml"
}

# Authentication Methods Configuration

# https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/okta
# Okta OIDC authentication configuration for Vault
resource "vault_jwt_auth_backend" "okta_oidc" {
  path        = "oidc"
  type        = "oidc"
  description = "Okta OIDC authentication"

  oidc_discovery_url = data.sops_file.oidc_secrets.data["okta_discovery_url"]
  oidc_client_id     = data.sops_file.oidc_secrets.data["okta_client_id"]
  oidc_client_secret = data.sops_file.oidc_secrets.data["okta_client_secret"]
  
  # Set default role
  default_role = "default"
}

# Default role for all Okta users
resource "vault_jwt_auth_backend_role" "default" {
  backend        = vault_jwt_auth_backend.okta_oidc.path
  role_name      = "default"
  token_policies = ["default", "developer"]  # Assign policies

  # Redirect URIs for OIDC callback
  allowed_redirect_uris = [
    "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",  # CLI callback
    "http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback"
  ]

  # Map the user claim
  user_claim   = "email"
  
  # Remove groups_claim if Okta doesn't provide it
  # You can re-enable this once you configure Okta to send groups
  # groups_claim = "groups"
  
  # OIDC scopes to request (removed 'groups' since Okta may not support it)
  oidc_scopes = ["openid", "email", "profile"]
  
  # Token settings
  token_ttl     = 3600  # 1 hour
  token_max_ttl = 7200  # 2 hours
  
  # Allow all users from Okta to authenticate
  # Add bound_claims here if you want to restrict to specific users/groups
  # Example:
  # bound_claims = {
  #   groups = "vault-users"
  # }
}

