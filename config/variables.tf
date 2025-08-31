# Vault Configuration Variables

variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = "https://127.0.0.1:8200"
}

# Vault token is provided via VAULT_TOKEN environment variable
# No need for a Terraform variable since the provider reads it automatically

# Variable for the plugin SHA256 
#variable "example_plugin_sha256" {
#  description = "SHA256 checksum of the example plugin binary"
#  type        = string
#}

