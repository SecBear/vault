# Vault binary package with UI support
{ pkgs, system, pname, ... }:
let
  version = "1.20.3"; # Latest stable version with UI
  
  # Define sources for each platform
  # Replace the hash with the one given in inital build error
  sources = {
    "x86_64-linux" = {
      url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_linux_amd64.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    "aarch64-linux" = {
      url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_linux_arm64.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    "x86_64-darwin" = {
      url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_darwin_amd64.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    "aarch64-darwin" = {
      url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_darwin_arm64.zip";
      sha256 = "sha256-zWuI+KFNyqoxnEKI25N4igXnXjoz+AXMU1WgGDKyfog=";
    };
  };
in
pkgs.stdenv.mkDerivation {
  pname = "vault";
  inherit version;
  
  src = pkgs.fetchzip {
    inherit (sources.${system}) url sha256;
    stripRoot = false;
  };
  
  nativeBuildInputs = with pkgs; [
    installShellFiles
  ];
  
  installPhase = ''
    runHook preInstall
    
    # Install the binary
    mkdir -p $out/bin
    cp vault $out/bin/vault
    chmod +x $out/bin/vault
    
    # Install shell completions
    echo "complete -C $out/bin/vault vault" > vault.bash
    installShellCompletion vault.bash
    
    runHook postInstall
  '';
  
  meta = with pkgs.lib; {
    description = "Tool for managing secrets (with UI support)";
    homepage = "https://www.vaultproject.io/";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    license = licenses.bsl11;
    mainProgram = "vault";
    platforms = builtins.attrNames sources;
    maintainers = with maintainers; [ 
        SecBear
    ]; 
  };
}
