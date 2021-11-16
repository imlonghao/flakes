{ pkgs, profiles, ... }:

{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
  ];

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    interfaces = {
      ens3.ipv6.addresses = [
        {
          address = "2a01:4f8:1c17:ea61::";
          prefixLength = 64;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    openssl
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

  # Docker
  virtualisation.docker.enable = true;

}
