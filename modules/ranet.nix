{
  config,
  pkgs,
  lib,
  self,
  ...
}:
with lib;
let
  cfg = config.services.ranet;
  swanMtu = cfg.mtu - 82;
  updown = pkgs.writeShellScript "swan-updown" ''
    id=$(${pkgs.jq}/bin/jq -r '.[0].nodes[] | select(.common_name == "${config.networking.hostName}") | .remarks.id' /persist/ranet-registry.json)
    LINK=swan$(printf '%08x\n' "$PLUTO_IF_ID_OUT")
    case "$PLUTO_VERB" in
        up-client)
            ip link add "$LINK" type xfrm if_id "$PLUTO_IF_ID_OUT"
            ip link set "$LINK" multicast on mtu ${toString swanMtu} up
            ip addr add "100.64.0.$id/32" dev "$LINK"
            ;;
        down-client)
            ip link del "$LINK"
            ;;
    esac
  '';
  postScript = pkgs.writeShellScript "post-script" ''
    myid=$(${pkgs.jq}/bin/jq -r '.[0].nodes[] | select(.common_name == "${config.networking.hostName}") | .remarks.id' /persist/ranet-registry.json)
    ${pkgs.iproute2}/bin/ip link show gravity || (
      ${pkgs.iproute2}/bin/ip link add gravity type vxlan local "100.64.0.$myid" id 114514 dstport 61919 noudpcsum &&
      ${pkgs.procps}/bin/sysctl -w net.ipv4.conf.gravity.rp_filter=0 &&
      ${pkgs.iproute2}/bin/ip addr add "100.64.1.$myid/24" dev gravity &&
      ${pkgs.iproute2}/bin/ip addr add "fd99:100:64:1::$myid/64" dev gravity &&
      ${pkgs.iproute2}/bin/ip link set gravity mtu 1368 &&
      ${pkgs.iproute2}/bin/ip link set gravity up
    ) || { ${pkgs.iproute2}/bin/ip link del gravity; exit; }
    fdb=$(${pkgs.iproute2}/bin/bridge fdb show dev gravity)
    for id in $(${pkgs.jq}/bin/jq -r '.[0].nodes[] | .remarks.id' /persist/ranet-registry.json); do
      [[ "$myid" == "$id" ]] && continue
      echo "$fdb" | grep " 100.64.0.$id " > /dev/null || ${pkgs.iproute2}/bin/bridge fdb append 00:00:00:00:00:00 dev gravity dst "100.64.0.$id"
    done
  '';
  configfile = pkgs.writeText "ranet.json" (
    builtins.toJSON ({
      organization = "imlonghao";
      common_name = config.networking.hostName;
      endpoints =
        [ ]
        ++ (
          if cfg.ipv4 then
            [
              {
                serial_number = "0";
                address_family = "ip4";
                port = cfg.port;
                updown = updown;
              }
            ]
          else
            [ ]
        )
        ++ (
          if cfg.ipv6 then
            [
              {
                serial_number = "1";
                address_family = "ip6";
                port = cfg.port;
                updown = updown;
              }
            ]
          else
            [ ]
        );
    })
  );
in
{
  options.services.ranet = {
    enable = mkEnableOption "ranet IPSEC";
    interface = mkOption {
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
    mtu = mkOption {
      type = types.int;
      description = "internet ethernet mtu";
      default = 1500;
    };
    id = mkOption {
      type = types.int;
      description = "node id";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.strongswan
      pkgs.ranet
      pkgs.ranetdebug
    ];
    sops.secrets.ranet = {
      sopsFile = "${self}/secrets/ranet.txt";
      format = "binary";
    };
    services.strongswan-swanctl = {
      enable = true;
      package = pkgs.strongswan_6;
      strongswan.extraConfig = ''
        charon {
          ikesa_table_size = 32
          ikesa_table_segments = 4
          reuse_ikesa = no
          interfaces_use = ${cfg.interface}
          port = 0
          port_nat_t = 15702
          retransmit_timeout = 30
          retransmit_base = 1
          process_route = no
          ignore_routing_tables = main
          install_routes = no
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
        ExecStartPre = "${pkgs.wget}/bin/wget -O /persist/ranet-registry.json https://f001.esd.cc/file/imlonghao-meow/2d6780b0-4c5e-4a02-9c0c-281102ee8354-registry.json";
        ExecStart = "${pkgs.ranet}/bin/ranet --config ${configfile} --registry /persist/ranet-registry.json --key ${config.sops.secrets.ranet.path} up";
        ExecStartPost = "-${postScript}";
        ConditionPathExists = [ "/persist/ranet-registry.json" ];
      };
      wants = [
        "network-online.target"
        "strongswan-swanctl.service"
      ];
      after = [
        "network-online.target"
        "strongswan-swanctl.service"
      ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.ranet = {
      timerConfig = {
        OnUnitActiveSec = "5min";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
    systemd.services.supervxlan = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.supervxlan}/bin/supervxlan";
        Environment = [
          "ID=${toString cfg.id}"
          "ENDPOINT=https://supervxlan.esd.cc"
        ];
        Restart = "on-failure";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
