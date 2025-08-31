# Vault Provider Configuration

terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      # Version managed by nixpkgs, not Terraform registry
    }
    sops = {
      source = "carlpett/sops"
      # Version managed by nixpkgs, not Terraform registry
    }
  }
}

# Configure the Vault provider
provider "vault" {
  address = var.vault_address
  # token automatically read from VAULT_TOKEN environment variable
  # can also be set via var.vault_token if needed
}

