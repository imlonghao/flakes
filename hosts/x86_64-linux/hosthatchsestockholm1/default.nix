{ self, pkgs, ... }:
{
  imports = [
    ./bird.nix
    ./borg.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/k3s/agent.nix"
    "${self}/profiles/docker"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    interfaces = {
      ens3 = {
        ipv6.addresses = [
          {
            address = "2a0e:dc0:2:cf29::1919";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [ docker-compose ];

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    id = 16;
  };

}
