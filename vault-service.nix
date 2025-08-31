# This file is an example of how you might configure the vault service for production
# on a NixOS machine
{
  config,
  lib,
  pkgs,
  ...
}: let
  externalVaultAddress = "https://vault.example-app.com";
  clusterPort = 8201;
  apiPort = 8200;
  #telemetryPort = 8202;
in {
  imports = [
  ];
  # HashiCorp Vault package
  environment.systemPackages = with pkgs; [
    vault
  ];

  # Security https://developer.hashicorp.com/vault/tutorials/day-one-raft/production-hardening
  swapDevices = lib.mkForce [];
  systemd.coredump.enable = false;

  services.vault = {
    enable = true;
    dev = true; # starts vault unsealed. modify this for production

    # Configure storage
    storageBackend = "raft";
    storagePath = "/var/lib/vault";
    storageConfig = ''
      # Raft config
      node_id = "node-1"
      # Add your retry_join stanzas here for HA
      #retry_join {
      #}
      #retry_join {
      #}
      #retry_join {
      #}
    '';
    # Configure listener
    address = "127.0.0.1:${clusterPort}";
    listenerExtraConfig = ''
    '';

    # Additional configuration stored in nix store (no sensitive info)
    extraConfig = ''
      ui = true
      max_lease_ttl = "24h"
      default_lease_ttl = "1h"

      # Advertise the internal interface
      api_addr = "http://127.0.0.1:${toString clusterPort}"
      cluster_addr = "http://127.0.0.1:${toString apiPort}"

      # Audit configuration
      audit {
        type = "file"
        options = {
          file_path = "/var/log/vault_audit.log"
          format = "json"
          log_raw = false
        }
      }
      # Both file and syslog for redundancy
      audit "syslog" {
        tag = "vault"
        facility = "AUTH"
      }
    '';

    # JSON or HCL-formatted configuration file that won't be stored in nix store
    #extraSettingsPaths = /path;
  };

  # Create audit log directory with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/log/vault 0750 vault vault -"
    "f /var/log/vault/audit.log 0640 vault vault -"
  ];

  # Optional: Configure log rotation for audit logs
  services.logrotate.settings."/var/log/vault/audit.log" = {
    rotate = 7;
    daily = true;
    compress = true;
    delaycompress = true;
    notifempty = true;
    create = "0640 vault vault";
    postrotate = ''
      # Signal Vault to reopen log files
      systemctl reload vault || true
    '';
  };

  # Open the firewall for the Vault port
  networking.firewall.allowedTCPPorts = [
    apiPort
    clusterPort
    #telemetryPort
  ];

  # VM-specific: Forward ports
  #virtualisation.vmVariant.virtualisation.forwardPorts = [
  #  {
  #    from = "host";
  #    host.port = clusterPort;
  #    guest.port = clusterPort;
  #  }
  #  {
  #    from = "host";
  #    host.port = apiPort;
  #    guest.port = apiPort;
  #  }
  #];
}
