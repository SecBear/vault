# Secret Engines in Root Namespace

# Enable KV v2 secrets engine
resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv-v2"
  description = "KV v2 secret storage"
}

# Enable transit secrets engine for encryption as a service
resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Transit encryption as a service"
}

# Plugin Registration and Configuration

# Register a plugin in Vault's plugin catalog
#resource "vault_generic_endpoint" "example_plugin" {
#  path                 = "sys/plugins/catalog/secret/example_plugin"
#  disable_read         = false
#  disable_delete       = true
#  ignore_absent_fields = true
#
#  data_json = jsonencode({
#    sha256  = var.example_plugin_sha256
#    command = "example_plugin"
#    args    = []
#  })
#}
#
## Mount the example secrets engine using the registered plugin
#resource "vault_mount" "example" {
#  path        = "example"
#  type        = "example_plugin"
#  description = "Example plugin configuration for demonstration purposes"
#
#  # Ensure plugin is registered before mounting
#  depends_on = [vault_generic_endpoint.example_plugin]
#}

