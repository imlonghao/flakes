{ pkgs, profiles, ... }: {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
    profiles.docker
    profiles.k3s.agent
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
    directories = [ "/etc/rancher" "/var/lib" "/root/.ssh" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [ ncdu ranet rclone rustic tmux ];

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.44/24";
    ipv6 = "2602:feda:1bf:deaf::44/64";
  };

  # ranet
  services.strongswan-swanctl = {
    enable = true;
    package = pkgs.strongswan;
    strongswan.extraConfig = ''
      charon {
        ikesa_table_size = 32
        ikesa_table_segments = 4
        reuse_ikesa = no
        interfaces_use = eno1
        port = 0
        port_nat_t = 15702
        retransmit_timeout = 30
        retransmit_base = 1
        plugins {
          socket-default {
            set_source = yes
            set_sourceif = yes
          }
          dhcp {
            load = no
          }
        }
      }
      charon-systemd {
        journal {
          default = -1
        }
      }
    '';
  };

}
