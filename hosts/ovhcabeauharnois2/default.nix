{ pkgs, profiles, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.rsshc
    profiles.k3s.agent
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    dhcpcd.allowInterfaces = [ "eno1" ];
    defaultGateway6 = {
      interface = "eno1";
      address = "2607:5300:0060:46ff:00ff:00ff:00ff:00ff";
    };
    interfaces = {
      eno1 = {
        ipv6.addresses = [
          {
            address = "2607:5300:60:4617::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/var/lib"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [
    ncdu
    ranet
    rclone
    rustic
    tmux
  ];

  # ranet
  services.ranet = {
    enable = true;
    interface = "eno1";
    id = 31;
  };

}
