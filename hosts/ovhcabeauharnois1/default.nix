{ pkgs, profiles, ... }: {
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
    profiles.docker
  ];

  boot.loader.grub.device = "/dev/sda";

  networking = {
    dhcpcd.allowInterfaces = [ "eno1" ];
    defaultGateway6 = {
      interface = "eno1";
      address = "2607:5300:0060:7fff:00ff:00ff:00ff:00ff";
    };
    interfaces = {
      eno1 = {
        ipv6.addresses = [{
          address = "2607:5300:60:7feb::1";
          prefixLength = 128;
        }];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib" "/root/.ssh" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.44/24";
    ipv6 = "2602:feda:1bf:deaf::44/64";
  };

}
