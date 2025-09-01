# SOPS Data Source for encrypted secrets
data "sops_file" "oidc_secrets" {
  source_file = "../okta-secrets.sops.yaml"
}

