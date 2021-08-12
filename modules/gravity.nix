{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.gravity;
in
{
  options.services.gravity = {
    enable = mkEnableOption "gravity overlay network";
    address = mkOption {
      type = types.str;
      description = "address to add into netns (as icmp source address)";
    };
    addressV6 = mkOption {
      type = types.str;
      description = "address to add into netns (as icmp source address) (IPv6)";
    };
    hostAddress = mkOption {
      type = types.str;
      description = "address on host";
    };
    hostAddressV6 = mkOption {
      type = types.str;
      description = "address on host (IPv6)";
    };
    netns = mkOption {
      type = types.str;
      description = "name of netns for wireguard interfaces";
      default = "rait";
    };
    link = mkOption {
      type = types.str;
      description = "name of link connecting netns";
      default = "gravity";
    };
    group = mkOption {
      type = types.int;
      description = "ifgroup of link connecting netns";
      default = 0;
    };
    socket = mkOption {
      type = types.str;
      description = "path of babeld control socket";
      default = "/run/babeld.ctl";
    };
    postStart = mkOption {
      type = types.listOf types.str;
      description = "additional commands to run after startup";
      default = [ ];
    };
  };
  config = mkIf cfg.enable {
    systemd.services.gravity = {
      serviceConfig = with pkgs;{
        ExecStartPre = [
          "${iproute2}/bin/ip netns add ${cfg.netns}"
          "${iproute2}/bin/ip link add ${cfg.link} address 00:00:00:00:00:02 group ${toString cfg.group} type veth peer host address 00:00:00:00:00:01 netns ${cfg.netns}"
          "${iproute2}/bin/ip link set ${cfg.link} up"
          "${iproute2}/bin/ip -n ${cfg.netns} link set host up"
          "${iproute2}/bin/ip -n ${cfg.netns} addr add ${cfg.address} dev host"
          "${iproute2}/bin/ip -n ${cfg.netns} addr add ${cfg.addressV6} dev host"
          "${iproute2}/bin/ip addr add ${cfg.hostAddress} dev ${cfg.link}"
          "${iproute2}/bin/ip addr add ${cfg.hostAddressV6} dev ${cfg.link}"
        ];
        ExecStart = "${iproute2}/bin/ip netns exec ${cfg.netns} ${babeld}/bin/babeld -c ${writeText "babeld.conf" ''
          random-id true
          local-path-readwrite ${cfg.socket}
          state-file ""
          pid-file ""
          interface placeholder
          redistribute local deny
        ''}";
        ExecStartPost = cfg.postStart;
        ExecStopPost = "${iproute2}/bin/ip netns del ${cfg.netns}";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
