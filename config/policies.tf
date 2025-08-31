# Policy definitions for Vault

# Operations Policy
resource "vault_policy" "operations" {
  name   = "operations"
  policy = file("${path.module}/policies/operations.hcl")
}

# Developer Policy
resource "vault_policy" "developer" {
  name   = "developer"
  policy = file("${path.module}/policies/developer.hcl")
}

# Admin Policy
resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("${path.module}/policies/admin.hcl")
}
