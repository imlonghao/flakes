{ config, pkgs, lib, sops, ... }:
with lib;
let
  cfg = config.services.ranet;
  updown = writeShellScript "swan-updown" ''
    LINK=swan$(printf '%08x\n' "$PLUTO_IF_ID_OUT")
    case "$PLUTO_VERB" in
        up-client)
            ip link add "$LINK" type xfrm if_id "$PLUTO_IF_ID_OUT"
            ip link set "$LINK" multicast on mtu 1418 up
            ;;
        down-client)
            ip link del "$LINK"
            ;;
    esac
  '';
  configfile = pkgs.writeText "ranet.json" (builtins.toJSON ({
    organization = "imlonghao";
    common_name = config.networking.hostName;
    endpoints = [ ] ++ (if cfg.ipv4 then [{
      serial_number = "0";
      address_family = "ip4";
      port = cfg.port;
      updown = updown;
    }] else
      [ ]) ++ (if cfg.ipv6 then [{
        serial_number = "1";
        address_family = "ip6";
        port = cfg.port;
        updown = updown;
      }] else
        [ ]);
  }));
in {
  options.services.ranet = {
    enable = mkEnableOption "ranet IPSEC";
    intnerface = mkOption {
      type = types.str;
      description = "interface";
    };
    ipv4 = mkOption {
      type = types.bool;
      description = "enable ipv4";
      default = true;
    };
    ipv6 = mkOption {
      type = types.bool;
      description = "enable ipv6";
      default = true;
    };
    port = mkOption {
      type = types.int;
      description = "port";
      default = 15702;
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.ranet.sopsFile = "${self}/secrets/ranet.txt";
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
    systemd.services.ranet = {
      serviceConfig = {
        Type = "simple";
        ExecStartPre =
          "${pkgs.wget}/bin/wget -O /etc/ranet-registry.json https://f001.esd.cc/file/imlonghao-meow/2d6780b0-4c5e-4a02-9c0c-281102ee8354-registry.json";
        ExecStart =
          "${pkgs.ranet}/bin/ranet --config ${configfile} --registry /etc/ranet-registry.json --key ${config.sops.secrets.ranet.path} up";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.ranet = {
      timerConfig = {
        OnCalendar = "*:0/5";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
