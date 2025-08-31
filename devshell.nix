{pkgs, perSystem, ...}:
  pkgs.mkShell {
    # Add build dependencies
    packages = with pkgs; [
      # builds vault 1.20.3 from source (defined in packages/) 
      # if taking too long, just use "vault" from upstream nixpkgs
      perSystem.self.vault 

      terraform
      jq
      curl
      httpie
      sops
    ];

    # Add environment variables
    env = {
      VAULT_ADDR = "http://127.0.0.1:8200";
      VAULT_TOKEN = "root";
    };

    # Load custom bash code
    shellHook = ''

      # This reads the key file content once when entering the shell
      if [ -f "./key.txt" ]; then
        export SOPS_AGE_KEY_FILE="$(realpath ./key.txt)"
      else
        echo "Warning: key.txt not found at ${toString ./.}/key.txt"
      fi

      echo ""
      echo "Vault POC Development Shell"
      echo "========================="
      echo ""
      echo "Vault Version:"
      echo "  $(vault --version)"
      echo ""
      echo "Environment:"
      echo "  VAULT_ADDR: $VAULT_ADDR"
      echo "  VAULT_TOKEN: $VAULT_TOKEN"
      echo ""

      alias vault-start='./scripts/start-vault.sh'
      alias vault-stop='pkill -f "vault server" || true'
      alias vault-init='cd terraform && terraform init && terraform apply -auto-approve'
      alias vault-destroy='cd terraform && terraform destroy -auto-approve'
    '';
  }
