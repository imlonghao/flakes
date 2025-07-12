{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ranet ];

  services.strongswan-swanctl = {
    enable = true;
    package = pkgs.strongswan_6;
    strongswan.extraConfig = ''
      charon {
        ikesa_table_size = 32
        ikesa_table_segments = 4
        reuse_ikesa = no
        interfaces_use = ${lib.strings.concatStringsSep "," cfg.ipsec.interfaces}
        port = 0
        port_nat_t = ${toString cfg.ipsec.port}
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
