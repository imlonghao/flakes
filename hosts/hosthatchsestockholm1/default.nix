{ pkgs, profiles, sops, ... }:
{
  imports = [
    ./bird.nix
    ./borg.nix
    ./hardware.nix
    profiles.mycore
    profiles.netdata
    profiles.users.root
    profiles.etherguard.edge
    profiles.exporter.node
    profiles.mtrsb
    profiles.rsshc
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    interfaces = {
      ens3 = {
        ipv6.addresses = [
          { address = "2a0e:dc0:2:cf29::1919"; prefixLength = 64; }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Docker
  virtualisation.docker.enable = true;

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.16/24";
    ipv6 = "2602:feda:1bf:deaf::16/64";
  };

}
