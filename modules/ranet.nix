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
  swanMtu = if cfg.iptfs then 2800 else cfg.mtu - 82;
  gravityMtu = if cfg.iptfs then 2750 else 1368;
  registry = "/persist/ranet-registry.json";
  registryUrl = "https://f001.esd.cc/file/imlonghao-meow/2d6780b0-4c5e-4a02-9c0c-281102ee8354-registry.json";
  prepareRegistry = pkgs.writeShellApplication {
    name = "prepare-ranet-registry";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      set -euo pipefail

      registry=$1
      url=$2
      hostname=$3
      node_id=$4

      validate_registry() {
        # Match Ranet's registry schema and the IDs used by the gravity network.
        # Slurp also rejects empty files and multiple top-level JSON documents.
        jq -se --arg hostname "$hostname" --arg node_id "$node_id" '
          def nonempty_string: type == "string" and length > 0;
          def fields($allowed): type == "object" and (keys - $allowed | length == 0);
          def unique_values: length == (unique | length);
          def valid_id:
            (type == "string" or type == "number")
            and (tostring | test("^[1-9][0-9]{0,2}$") and (tonumber <= 254));

          length == 1 and (.[0] |
            type == "array" and length > 0
            and all(.[];
              fields(["organization", "public_key", "nodes"])
              and (.organization | nonempty_string)
              and (.public_key | nonempty_string)
              and (.nodes | type == "array")
              and all(.nodes[];
                fields(["common_name", "endpoints", "remarks"])
                and (.common_name | nonempty_string)
                and (.endpoints | type == "array")
                and all(.endpoints[];
                  fields(["serial_number", "address_family", "address", "port"])
                  and (.serial_number | nonempty_string)
                  and (.address_family == "ip4" or .address_family == "ip6")
                  and (.address == null or (.address | nonempty_string))
                  and (.port | type == "number" and . == floor and . >= 1 and . <= 65535)
                )
                and ([.endpoints[].serial_number] | unique_values)
              )
              and ([.nodes[].common_name] | unique_values)
            )
            and ([.[].organization] | unique_values)
            and .[0].organization == "imlonghao"
            and all(.[0].nodes[]; .remarks.id | valid_id)
            and ([.[0].nodes[].remarks.id | tostring] | unique_values)
            and ([.[0].nodes[] | select(.common_name == $hostname)] |
              length == 1 and (.[0].remarks.id | tostring) == $node_id
            )
          )
        ' "$1" >/dev/null
      }

      umask 077
      temporary=$(mktemp "$registry.tmp.XXXXXX")
      trap 'rm -f -- "$temporary"' EXIT
      trap 'exit 1' HUP INT TERM

      if curl --fail --silent --show-error --location \
        --proto '=https' --proto-redir '=https' \
        --connect-timeout 5 --max-time 20 --output "$temporary" "$url"; then
        if validate_registry "$temporary"; then
          # The temporary file is on the same filesystem as the persistent cache.
          mv -f -- "$temporary" "$registry"
          echo "ranet: installed validated registry"
          exit 0
        fi
        echo "ranet: downloaded invalid registry; keeping existing cache" >&2
      else
        echo "ranet: registry download failed; checking existing cache" >&2
      fi

      if [[ -f "$registry" ]] && validate_registry "$registry"; then
        echo "ranet: using validated cached registry" >&2
      else
        echo "ranet: no valid registry available for $hostname (node $node_id)" >&2
        exit 1
      fi
    '';
  };
  setupGravity = pkgs.writeShellApplication {
    name = "setup-ranet-gravity";
    runtimeInputs = [
      pkgs.gnugrep
      pkgs.iproute2
      pkgs.iptables
      pkgs.jq
      pkgs.procps
    ];
    text = ''
      set -euo pipefail

      registry=$1
      node_id=$2
      mtu=$3
      created=false

      cleanup() {
        status=$?
        if [[ $status -ne 0 && $created == true ]]; then
          ip link del gravity || true
        fi
        exit "$status"
      }
      trap cleanup EXIT

      iptables -C INPUT ! -s 100.64.0.0/24 -p udp --dport 61919 -j REJECT \
        || iptables -A INPUT ! -s 100.64.0.0/24 -p udp --dport 61919 -j REJECT

      if ! ip link show gravity >/dev/null 2>&1; then
        ip link add gravity type vxlan local "100.64.0.$node_id" id 114514 dstport 61919 noudpcsum
        created=true
      fi

      # Reconcile existing interfaces too, including changes to the configured MTU.
      sysctl -w net.ipv4.conf.gravity.rp_filter=0
      ip addr replace "100.64.1.$node_id/24" dev gravity
      ip addr replace "fd99:100:64:1::$node_id/64" dev gravity
      ip link set gravity mtu "$mtu"
      ip link set gravity up

      fdb=$(bridge fdb show dev gravity)
      ids=$(jq -r '.[0].nodes[].remarks.id | tostring' "$registry")
      for id in $ids; do
        [[ "$node_id" == "$id" ]] && continue
        if ! grep -Fq -- " 100.64.0.$id " <<< "$fdb"; then
          bridge fdb append 00:00:00:00:00:00 dev gravity dst "100.64.0.$id"
        fi
      done
    '';
  };
  updown = pkgs.writeShellScript "swan-updown" ''
    id=${toString cfg.id}
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
  configfile = pkgs.writeText "ranet.json" (
    builtins.toJSON ({
      organization = "imlonghao";
      common_name = config.networking.hostName;
      experimental = {
        iptfs = cfg.iptfs;
      };
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
      type = types.ints.between 1 254;
      description = "node id";
    };
    iptfs = mkOption {
      type = types.bool;
      description = "AGGFRAG Mode / IP-TFS";
      default = false;
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.strongswan
      pkgs.ranet
    ];
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
          iptfs {
            drop_time = 3000000
            reorder_window = 8
            init_delay = 300
            max_queue_size = 4194304
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
        Type = "oneshot";
        ExecStartPre = "${lib.getExe prepareRegistry} ${
          lib.escapeShellArgs [
            registry
            registryUrl
            config.networking.hostName
            (toString cfg.id)
          ]
        }";
        ExecStart = "${pkgs.ranet}/bin/ranet --config ${configfile} --registry ${registry} --key ${config.sops.secrets.ranet.path} up";
        ExecStartPost = "${lib.getExe setupGravity} ${
          lib.escapeShellArgs [
            registry
            (toString cfg.id)
            (toString gravityMtu)
          ]
        }";
        TimeoutStartSec = "2min";
      };
      wants = [ "network-online.target" ];
      requires = [ "strongswan-swanctl.service" ];
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
