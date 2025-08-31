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
}

