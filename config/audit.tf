# Audit Configuration for Vault
#
# Audit devices are now automatically configured via Terraform
# The log directory is created via NixOS configuration in vault.tf

# File-based audit device for all nodes
# Each node writes to its own local audit log
resource "vault_audit" "file" {
  type = "file"
  path = "file"

  options = {
    file_path = "/var/log/vault/audit.log"

    # Log raw request/response data - set to false to hash sensitive data  
    log_raw = "false"

    # Format: json or jsonx (jsonx includes more metadata but isn't jq-parseable)
    format = "json"
  }

  description = "File-based audit logging"
}

# Future: For centralized logging: uncomment syslog or socket audit device below
# Examples: ELK (syslog), Splunk (syslog), Grafana Loki (file+promtail)

# resource "vault_audit" "syslog" {
#   type = "syslog"
#   path = "syslog"
#   options = {
#     facility = "LOCAL0"
#     tag      = "vault-audit"
#     format   = "jsonx"
#     address  = "log-server:514"
#   }
# }

# Create the audit viewer policy
resource "vault_policy" "audit_viewer" {
  name   = "audit-viewer"
  policy = file("${path.module}/policies/audit-viewer.hcl")
}

# Output useful audit commands for operators
output "audit_commands" {
  value = {
    check_audit_devices = "vault audit list"
    check_audit_status  = "vault audit list -detailed"
    view_audit_logs     = "tail -f /var/log/vault/audit.log | jq ."
    test_audit_hash     = "echo -n 'test-value' | vault write sys/audit-hash/file input=-"
    search_audit_logs   = "grep REQUEST_ID /var/log/vault/audit.log | jq ."
  }

  description = "Useful commands for managing and viewing audit logs"
}

