{ config, pkgs, lib, sops, self, ... }:
with lib;
let
  cfg = config.services.ranet;
  updown = pkgs.writeShellScript "swan-updown" ''
    id=$(${pkgs.jq}/bin/jq -r '.[0].nodes[] | select(.common_name == "${config.networking.hostName}") | .remarks.id' /persist/ranet-registry.json)
    LINK=swan$(printf '%08x\n' "$PLUTO_IF_ID_OUT")
    case "$PLUTO_VERB" in
        up-client)
            ip link add "$LINK" type xfrm if_id "$PLUTO_IF_ID_OUT"
            ip link set "$LINK" multicast on mtu 1418 up
            ip addr add "100.64.0.$id/32" dev "$LINK"
            ;;
        down-client)
            ip link del "$LINK"
            ;;
    esac
  '';
  postScript = pkgs.writeShellScript "post-script" ''
    myid=$(${pkgs.jq}/bin/jq -r '.[0].nodes[] | select(.common_name == "${config.networking.hostName}") | .remarks.id' /persist/ranet-registry.json)
    mac=$(${pkgs.jq}/bin/jq -r '.[0].nodes[] | select(.common_name == "${config.networking.hostName}") | .remarks.mac' /persist/ranet-registry.json)
    ${pkgs.iproute2}/bin/ip link show gravity || (
      ${pkgs.iproute2}/bin/ip link add gravity type vxlan local "100.64.0.$myid" id 114514 dstport 61919 &&
      ${pkgs.iproute2}/bin/ip addr add "100.64.1.$myid/24" dev gravity &&
      ${pkgs.iproute2}/bin/ip addr add "fd99:100:64:1::$myid/64" dev gravity &&
      ${pkgs.iproute2}/bin/ip link set gravity address "$mac" &&
      ${pkgs.iproute2}/bin/ip link set gravity arp off &&
      ${pkgs.iproute2}/bin/ip link set gravity mtu 1368 &&
      ${pkgs.iproute2}/bin/ip link set gravity up
    ) || ${pkgs.iproute2}/bin/ip link del gravity
    fdb=$(${pkgs.iproute2}/bin/bridge fdb show dev gravity)
    for node in $(${pkgs.jq}/bin/jq -r '.[0].nodes[] | "\(.remarks.id),\(.remarks.mac)"' /persist/ranet-registry.json); do
      id=$(echo "$node" | ${pkgs.gawk}/bin/awk -F, '{print $1}')
      hex=$(printf "%X\n" "$id")
      mac=$(echo "$node" | ${pkgs.gawk}/bin/awk -F, '{print $2}')
      [[ "$myid" == "$id" ]] && continue
      ${pkgs.iproute2}/bin/ip nei get "100.64.1.$id" dev gravity | grep "$mac" || ${pkgs.iproute2}/bin/ip nei replace "100.64.1.$id" dev gravity lladdr "$mac"
      ${pkgs.iproute2}/bin/ip nei get "fd99:100:64:1::$id" dev gravity | grep "$mac" || ${pkgs.iproute2}/bin/ip nei replace "fd99:100:64:1::$id" dev gravity lladdr "$mac"
      echo "$fdb" | grep "$mac" > /dev/null || ${pkgs.iproute2}/bin/bridge fdb add "$mac" dev gravity dst "100.64.0.$id"
    done
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
  };
  config = mkIf cfg.enable {
    sops.secrets.ranet = {
      sopsFile = "${self}/secrets/ranet.txt";
      format = "binary";
    };
    services.strongswan-swanctl = {
      enable = true;
      package = pkgs.strongswan;
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
        ExecStartPre =
          "${pkgs.wget}/bin/wget -O /persist/ranet-registry.json https://f001.esd.cc/file/imlonghao-meow/2d6780b0-4c5e-4a02-9c0c-281102ee8354-registry.json";
        ExecStart =
          "${pkgs.ranet}/bin/ranet --config ${configfile} --registry /persist/ranet-registry.json --key ${config.sops.secrets.ranet.path} up";
        ExecStartPost = postScript;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.ranet = {
      timerConfig = {
        OnUnitActiveSec = "5min";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
