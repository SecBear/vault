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
- Okta developer account or access to Okta organization

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

3. **Configure Okta secrets:**

   First, you need to setup your encryption key. For this repository, I've
   included the age package in the devshell.nix for convenience. The
   devshell.nix expects you have an age key located at `./key.txt`. In
   production, I recommend using a secure key management system.

   With age, you can generate one with:

   ```bash
   age-keygen -o ./key.txt

   # Reload the devshell to populate the SOPS_AGE_KEY_FILE env var which sops will use to encrypt secrets
   direnv reload  # or `nix develop` w/o direnv
   ```

   Add your Okta configuration secrets to `okta-secrets.sops.yaml.example`
   (which we'll encrypt):
   ```yaml
   okta_discovery_url: "https://your-domain.okta.com"
   okta_client_id: "your-client-id"
   okta_client_secret: "your-client-secret"
   ```

   Overwrite my existing encrypted file with the new secrets:
   ```bash
   mv config/okta-secrets.sops.yaml.example config/okta-secrets.sops.yaml
   ```

   Once configured, encrypt those secrets
   ```bash
   sops -e -i config/okta-secrets.sops.yaml
   ```

4. **Start Vault in dev mode:**
   ```bash
   vault server -dev
   ```

5. **Apply Terraform configuration:**

   This repository uses terraform to manage the configuration of the vault,
   instead of manually running commands. This way, we can
   configure the entire vault including policies, authentication methods,
   secrets engines, auditing, etc. with a single tf apply.

   ```bash
   cd config
   terraform init
   terraform apply
   ```

6. **Access Vault:**
   - UI: http://localhost:8200
   - CLI: `vault login -method=oidc`

## Project Structure

```
vault/
├── config/              # Terraform configurations
│   ├── *.tf            # Terraform resources
│   ├── policies/       # Vault policies
│   └── okta-secrets.sops.yaml  # Encrypted Okta credentials
├── packages/           # Nix packages
│   └── vault.nix      # Custom Vault package (v1.20.3)
├── modules/           # Nix modules
│   └── vault.nix      # Vault service configuration module
├── devshell.nix       # Development environment
├── flake.nix          # Nix flake configuration
├── .sops.yaml         # SOPS encryption config
└── key.txt            # Age private key (git-ignored)
```

## Configuration

### Okta Setup

1. **Create an OIDC application in Okta:**
   - Application type: Web
   - Grant types: Authorization Code
   - Sign-in redirect URIs:
     - `http://localhost:8200/ui/vault/auth/oidc/oidc/callback`
     - `http://localhost:8250/oidc/callback`

2. **Configure groups claim:**
   - In your OIDC app → Sign On tab
   - Edit OpenID Connect ID Token
   - Add groups claim:
     - Name: `groups`
     - Include in: ID Token (Always)
     - Value type: Groups
     - Filter: Starts with `vault-`

3. **Create Okta groups:**
   - `vault-admins` - System administrators
   - `vault-developers` - Development team
   - `vault-operations` - Operations team
   - `vault-audit-viewers` - Audit log viewers

### Vault Policies

| Policy         | Description           | Key Permissions                                       |
| -------------- | --------------------- | ----------------------------------------------------- |
| `admin`        | System administrators | Full system access except root operations             |
| `developer`    | Development team      | Access to developer namespace, use transit encryption |
| `operations`   | Operations team       | Manage operations namespace, PKI, shared secrets      |
| `audit-viewer` | Audit viewers         | Read-only access to audit logs                        |

### TODO

- add PKI secrets engine
