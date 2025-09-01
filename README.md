# Vault with Okta OIDC Integration

A proof-of-concept HashiCorp Vault setup with Okta OIDC authentication, managed
via Terraform and Nix. This project allows me to test out different
configurations and features of Vault in a reproducible environment.

## Overview

This project includes:

- 🔐 HashiCorp Vault 1.20.3 configuration with UI support
- 🔑 Okta OIDC authentication with group-based authorization
- 🏗️ Infrastructure & Policy as Code using Terraform
- ❄️ Reproducible development environment using Nix flakes
- 🔒 Secrets management with SOPS and age encryption
- 📝 Audit logging and compliance features

## Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [direnv](https://direnv.net/) (optional but recommended)
- Okta super admin account or access to Okta organization

Note: if you don't have Nix installed, you can still follow along with your own
vault binary installed on your system. You can install vault for your system
[here](https://developer.hashicorp.com/vault/install)

### Setup

1. **Clone and enter the repository:**
   ```bash
   git clone https://github.com/secbear/vault
   cd vault
   ```

2. **Enter the Nix development shell:**
   ```bash
   nix develop
   # or with direnv:
   direnv allow
   ```

3. **Configure Okta and secrets:**

   Generate age encryption key and configure SOPS:
   ```bash
   age-keygen -o ./key.txt
   direnv reload  # populates SOPS_AGE_KEY_FILE
   ```

   Create Terraform service app in Okta Admin Console:
   - **Service app**: Grant types = Client Credentials, generate private key

   Configure Terraform provider secrets:
   ```bash
   # Create unencrypted file first
   cat > config/okta/okta-terraform-secrets.yaml <<EOF
   okta_org_name: "your-okta-org"
   okta_client_id: "your-terraform-app-client-id"
   okta_private_key_id: "key-id-from-okta"
   okta_private_key: |
     -----BEGIN PRIVATE KEY-----
     your-private-key
     -----END PRIVATE KEY-----
   EOF

   # Encrypt in-place
   sops -e -i config/okta/okta-terraform-secrets.yaml
   mv config/okta/okta-terraform-secrets.yaml config/okta/okta-terraform-secrets.sops.yaml
   ```

4. **Create Okta infrastructure:**
   ```bash
   cd config/okta
   terraform init && terraform apply
   ```

5. **Extract Vault app credentials:** From Okta Admin Console → Applications →
   Vault app → General tab:
   - Copy Client ID and Client Secret

   Configure Vault OIDC secrets:
   ```bash
   # Create unencrypted file first
   cat > config/vault/okta-vault-secrets.yaml <<EOF
   okta_discovery_url: "https://your-domain.okta.com"
   okta_client_id: "vault-web-app-client-id"
   okta_client_secret: "vault-web-app-client-secret"
   EOF

   # Encrypt in-place
   sops -e -i config/vault/okta-vault-secrets.yaml
   mv config/vault/okta-vault-secrets.yaml config/vault/okta-vault-secrets.sops.yaml
   ```

6. **Start Vault and configure:**
   ```bash
   vault server -dev -dev-root-token-id="root"
   ```
   In new terminal:
   ```bash
   export VAULT_ADDR="http://127.0.0.1:8200"
   export VAULT_TOKEN="root"

   cd config/vault
   terraform init && terraform apply
   ```

7. **Access Vault:**
   - UI: http://localhost:8200
   - CLI: `vault login -method=oidc`

## Project Structure

```
vault/
├── config/                          # Terraform configurations
│   ├── okta/                        # Okta infrastructure (groups, apps)
│   │   └── okta-secrets.sops.yaml   # Terraform Okta app secrets
│   └── vault/                       # Vault configuration (auth, policies)
│       └── okta-secrets.sops.yaml   # Vault Okta OIDC secrets  
├── packages/vault.nix               # Custom Vault v1.20.3 package
├── modules/vault.nix                # NixOS service module (example, unused)
├── vault-service.nix                # Production NixOS config (example, unused)
├── devshell.nix                     # Development environment
├── flake.nix                        # Nix flake configuration
└── key.txt                          # Age private key (git-ignored)
```

## Configuration

### Okta Setup

**Phase 1**: Manual service app creation for Terraform provider authentication
**Phase 2**: Terraform-managed groups and Vault web app creation\

Terraform creates:

- Four Vault groups (`vault-admins`, `vault-developers`, `vault-operators`,
  `vault-audit-viewers`)
- Web application for Vault OIDC with proper redirect URIs (`omit_secret = true`
  by default)

### Vault Policies

| Policy         | Description           | Key Permissions                                       |
| -------------- | --------------------- | ----------------------------------------------------- |
| `admin`        | System administrators | Full system access except root operations             |
| `developer`    | Development team      | Access to developer namespace, use transit encryption |
| `operations`   | Operations team       | Manage operations namespace, PKI, shared secrets      |
| `audit-viewer` | Audit viewers         | Read-only access to audit logs                        |

### SOPS Operations

**Edit encrypted files:**

```bash
# Decrypt, edit, re-encrypt automatically
sops config/okta/okta-terraform-secrets.sops.yaml
sops config/vault/okta-vault-secrets.sops.yaml
```

**View encrypted files:**

```bash
# View decrypted content (read-only)
sops -d config/okta/okta-terraform-secrets.sops.yaml
sops -d config/vault/okta-vault-secrets.sops.yaml
```

**Encrypt new files:**

```bash
# Create plaintext file, then encrypt
sops -e -i your-secrets.yaml
```

### TODO

- PKI secrets engine configuration
- Add Auth methods (LDAP, Kubernetes)
- Database dynamic credentials
