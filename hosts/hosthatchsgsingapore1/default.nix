{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.rait
    profiles.pingfinder
    profiles.nomad
    profiles.vault
  ];

  boot.loader.grub.device = "/dev/vda";
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.defaultGateway6 = {
    address = "2406:ef80:2::1";
  };
  networking.interfaces.ens3.ipv6.addresses = [
    {
      address = "2406:ef80:2:e::";
      prefixLength = 48;
    }
  ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.2";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:2::";
      prefixLength = 64;
    }
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/run/secrets"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.gravity = {
    enable = true;
    address = "100.64.88.61/30";
    addressV6 = "2602:feda:1bf:a:10::1/80";
    hostAddress = "100.64.88.62/30";
    hostAddressV6 = "2602:feda:1bf:a:10::2/80";
  };

  # Nomad
  environment.etc."nomad-mutable.hcl".text = ''
    bind_addr = "103.167.150.135"
    client {
      meta = {
        traefik = "1"
      }
      host_volume "n8n" {
        path = "/persist/docker/n8n"
      }
      host_volume "n8n-mysql" {
        path = "/persist/docker/n8n-docker"
      }
      host_volume "joplin" {
        path = "/persist/docker/joplin"
      }
      host_volume "bitwarden" {
        path = "/persist/docker/bitwarden"
      }
      host_volume "umami" {
        path = "/persist/docker/umami"
      }
    }
  '';
  services.nomad.extraSettingsPaths = [ "/etc/nomad-mutable.hcl" ];

  # Vault
  services.vault.address = "100.64.88.62:8200";

}
