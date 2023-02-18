{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.vxwg;
  cfgType = with types; submodule {
    freeformType = settingsFormat.type;
    options = {
      publicKey = mkOption {
        type = str;
        example = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
      };
      ip = mkOption {
        type = str;
        example = "169.254.3.175";
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
in
{
  options.vxwg = {
    enable = mkEnableOption "VXLAN over WireGuard";
    ips = mkOption {
      type = with types; listOf str;
      example = [
        "172.20.10.244/24"
        "2001:db8:42:0:ce39:2471:79bb:a152/64"
      ];
    };
    mac = mkOption {
      type = types.str;
      example = "26:71:79:bb:a1:52";
    };
    peers = mkOption {
      default = { };
      type = types.attrsOf cfgType;
    };
    config = mkIf cfg.enable {
      networking.wireguard.interfaces.mesh = {
        ips = cfg.peers."${config.networking.hostName}".ip + "/24";
        listenPort = cfg.peers."${config.networking.hostName}".port;
        allowedIPsAsRoutes = false;
        privateKeyFile = config.sops.secrets.wireguard.path;
        mtu = 1550;
        preSetup = [
          "${pkgs.iproute2}/bin/ip link add v%i address ${cfg.mac} mtu 1500 type vxlan id 4652375 dstport 4789 ttl 1 noudpcsum || true"
          "${pkgs.ethtool}/bin/ethtool -K v%i tx off rx off"
          "${pkgs.procps}/bin/sysctl -w net.ipv4.conf.v%i.accept_redirects=0 net.ipv4.conf.v%i.send_redirects=0 net.ipv6.conf.v%i.accept_redirects=0"
        ] ++ forEach cfg.ips (x: "${pkgs.iproute2}/bin/ip address add ${x} dev v%i || true");
        postSetup = forEach (catAttrs (attrValues (filterAttrs (k: v: k != config.networking.hostName) cfg.peers)))
          (
            x: "${pkgs.iproute2}/bin/bridge fdb append 00:00:00:00:00:00 dev v%i dst ${x} via %i"
          ) ++ [
          "${pkgs.iproute2}/bin/ip link set v%i up"
        ];
        postShutdown = [
          "${pkgs.iproute2}/bin/ip link set v%i down"
          "${pkgs.iproute2}/bin/ip link delete v%i"
        ];
        peers = map
          (x: {
            endpoint = "${x.endpoint}:${toString x.port}";
            publicKey = x.publicKey;
            allowedIPs = [ "${x.ip}/32" ];
          })
          attrValues
          (filterAttrs (k: v: k != config.networking.hostName) cfg.peers);
      };
    };
  }
