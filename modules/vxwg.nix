{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.vxwg;
  cfgType = with types;
    submodule {
      options = {
        publicKey = mkOption {
          type = str;
          example = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
        };
        id = mkOption {
          type = types.int;
          example = 1;
        };
        mac = mkOption {
          type = types.str;
          example = "26:71:79:bb:a1:52";
        };
        endpoint = mkOption {
          type = nullOr str;
          example = "127.0.0.1";
        };
        port = mkOption {
          type = port;
          example = 1919;
        };
      };
    };
  id = toString cfg.peers.${config.networking.hostName}.id;
  mac = cfg.peers.${config.networking.hostName}.mac;
in {
  options.vxwg = {
    enable = mkEnableOption "VXLAN over WireGuard";
    peers = mkOption {
      default = { };
      type = types.attrsOf cfgType;
    };
  };
  config = mkIf cfg.enable {
    networking.wireguard.interfaces.mesh = {
      ips = [ "100.88.0.${id}/24" ];
      listenPort = cfg.peers."${config.networking.hostName}".port;
      allowedIPsAsRoutes = false;
      privateKeyFile = config.sops.secrets.wireguard.path;
      mtu = 1550;
      preSetup = [
        "${pkgs.iproute2}/bin/ip link add vmesh address ${mac} mtu 1500 type vxlan id 4652375 dstport 4789 ttl 1 noudpcsum || true"
        "${pkgs.ethtool}/bin/ethtool -K vmesh tx off rx off"
        "${pkgs.procps}/bin/sysctl -w net.ipv4.conf.vmesh.accept_redirects=0 net.ipv4.conf.vmesh.send_redirects=0 net.ipv6.conf.vmesh.accept_redirects=0"
        "${pkgs.iproute2}/bin/ip address add 100.88.1.${id}/32 dev vmesh || true"
        "${pkgs.iproute2}/bin/ip address add 2602:feda:1bf:1919::${id}/64 dev vmesh || true"
      ];
      postSetup = (forEach (catAttrs "id" (attrValues
        (filterAttrs (k: v: k != config.networking.hostName) cfg.peers))) (x:
          "${pkgs.iproute2}/bin/bridge fdb append 00:00:00:00:00:00 dev vmesh dst 100.88.0.${
            toString x
          } via mesh")) ++ [ "${pkgs.iproute2}/bin/ip link set vmesh up" ];
      postShutdown = [
        "${pkgs.iproute2}/bin/ip link set vmesh down"
        "${pkgs.iproute2}/bin/ip link delete vmesh"
      ];
      peers = map (x: {
        endpoint = "${x.endpoint}:${toString x.port}";
        publicKey = x.publicKey;
        allowedIPs = [ "100.88.0.${toString x.id}/32" ];
      }) (attrValues
        (filterAttrs (k: v: k != config.networking.hostName) cfg.peers));
    };
  };
}
