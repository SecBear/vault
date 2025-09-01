# Okta management through terraform
# https://developer.okta.com/docs/guides/terraform-landing-page/main/
# https://developer.okta.com/docs/guides/terraform-enable-org-access/main/
# for admin roles to assign the terraform okta application, see:  
# https://help.okta.com/oie/en-us/content/topics/security/administrators-admin-comparison.htm?cshid=ext-administrators-admin-comparison
# for this example, we've setup org admin and app admin roles

terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      # version = "~> 5.3.0" # version managed by nixpkgs
    }
    sops = {
      source = "carlpett/sops"
      # Version managed by nixpkgs, not Terraform registry
    }
  }
}


# Fetch secrets from SOPS encrypted file
provider "okta" {
  org_name       = data.sops_file.oidc_secrets.data["okta_org_name"]
  base_url       = "okta.com"
  client_id      = data.sops_file.oidc_secrets.data["okta_client_id"]
  private_key    = data.sops_file.oidc_secrets.data["okta_private_key"]
  private_key_id = data.sops_file.oidc_secrets.data["okta_private_key_id"]
  scopes         = ["okta.groups.manage", "okta.apps.manage"]
}
