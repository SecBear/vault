# ROOT TOKEN REVOCATION - FINAL BOOTSTRAP STEP
#
# WARNING: This will revoke the root token being used by Terraform!
# After this runs, future terraform operations must use OIDC auth

variable "revoke_root_token" {
  description = "Set to true to revoke root token after setup is complete"
  type        = bool
  default     = false
}

variable "root_token" {
  description = "Root token to revoke (only used when revoke_root_token=true)"
  type        = string
  default     = ""
  sensitive   = true
}

resource "null_resource" "revoke_root_token" {
  # Only create this resource if explicitly enabled
  count = var.revoke_root_token ? 1 : 0

  # Ensure this runs AFTER everything else
  depends_on = [
    vault_jwt_auth_backend.okta_oidc,
    vault_mount.transit,
  ]

  provisioner "local-exec" {
    command = <<-EOF
      echo "================================================"
      echo "WARNING: Revoking root token in 5 seconds..."
      echo "This is irreversible!"
      echo "Press Ctrl+C now to abort"
      echo "================================================"
      sleep 5
      
      # Use the provided root token
      curl -X POST \
        -H "X-Vault-Token: ${var.root_token}" \
        ${var.vault_address}/v1/auth/token/revoke-self
      
      echo ""
      echo "Root token revoked successfully!"
      echo "Use 'bao login -method=oidc role=admin' for future operations"
    EOF

    environment = {
      VAULT_ADDR = var.vault_address
    }
  }
}

