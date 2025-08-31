# Vault Configuration Outputs
# TODO Change to Okta

output "vault_auth_oidc_path" {
  description = "Path where Okta OIDC auth is mounted"
  value       = vault_jwt_auth_backend.okta_oidc.path
}

output "vault_policies" {
  description = "List of configured policies"
  value = {
    admin      = vault_policy.admin.name
    operations = vault_policy.operations.name
    developer  = vault_policy.developer.name
  }
}

#output "oidc_roles" {
#  description = "Okta OIDC role mappings"
#  value = {
#    default    = vault_jwt_auth_backend_role.default.role_name
#    admin      = vault_jwt_auth_backend_role.admin.role_name
#    operations = vault_jwt_auth_backend_role.operations.role_name
#  }
#}

