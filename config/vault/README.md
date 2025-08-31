1. Create Groups in Okta

In Okta Admin Console, create groups that match your Vault policies:

- vault-admins
- vault-developers
- vault-operations
- vault-audit-viewers

2. Configure Okta to send groups in the token

In your Okta OIDC app:

1. Go to Sign On tab → Edit OpenID Connect ID Token
2. Add a groups claim: - Claim name: groups - Include in token type: ID Token
   (Always) - Value type: Groups - Filter: Matches regex: .* (or Starts with:
   vault- to only include vault groups)
