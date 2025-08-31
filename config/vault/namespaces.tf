# Team-based namespaces for vault
# Each team gets their own isolated namespace with appropriate secret engines
# This is an enterprise only feature, but is available in the open source fork OpenBao

# Admin namespace - full infrastructure management
#resource "vault_namespace" "admin" {
#  path = "admin"
#}
#
## Operations namespace - infrastructure operations
#resource "vault_namespace" "operations" {
#  path = "operations"
#}
#
## Developer namespace - application development
#resource "vault_namespace" "developer" {
#  path = "developer"
#}
#
## Secret engines for admin namespace
#resource "vault_mount" "admin_secret" {
#  namespace   = vault_namespace.admin.path
#  path        = "secret"
#  type        = "kv-v2"
#  description = "Admin team secrets"
#}
#
#resource "vault_mount" "admin_database" {
#  namespace   = vault_namespace.admin.path
#  path        = "database"
#  type        = "database"
#  description = "Database credential management for admins"
#}

# We don't have AWS plugin rn
#resource "vault_mount" "admin_aws" {
#  namespace = vault_namespace.admin.path
#  path      = "aws"
#  type      = "aws"
#  description = "AWS credential management"
#}

#resource "vault_mount" "admin_pki" {
#  namespace   = vault_namespace.admin.path
#  path        = "pki"
#  type        = "pki"
#  description = "Admin PKI for infrastructure certificates"
#
#  default_lease_ttl_seconds = 86400   # 1 day
#  max_lease_ttl_seconds     = 2592000 # 30 days
#}
#
## Secret engines for operations namespace
#resource "vault_mount" "operations_secret" {
#  namespace   = vault_namespace.operations.path
#  path        = "secret"
#  type        = "kv-v2"
#  description = "Operations team secrets"
#}
#
#resource "vault_mount" "operations_ssh" {
#  namespace   = vault_namespace.operations.path
#  path        = "ssh"
#  type        = "ssh"
#  description = "SSH key management for operations"
#}
#
#resource "vault_mount" "operations_database" {
#  namespace   = vault_namespace.operations.path
#  path        = "database"
#  type        = "database"
#  description = "Read-only database access for operations"
#}
#
## Secret engines for developer namespace
#resource "vault_mount" "developer_secret" {
#  namespace   = vault_namespace.developer.path
#  path        = "secret"
#  type        = "kv-v2"
#  description = "Developer application secrets"
#}

# Shared services remain in root namespace (already configured)
# - oidc/ (auth) - auth.tf
# - transit/ (encryption) - secrets.tf
# - secret/ (shared KV store) - secrets.tf
