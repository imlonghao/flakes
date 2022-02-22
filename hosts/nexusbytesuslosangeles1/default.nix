{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIEOCEUAAQIT1nwWbtit9WIFtkf5/0sd8IcMw3CFcoPzoAAAAIKTz5EVR6k/BP+JyVoVFYrd3Bnxmo+ATsrSKElPhblXxAAAAAAAAAAAAAAACAAAAF25leHVzYnl0ZXN1c2xvc2FuZ2VsZXMxAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABJAAAAIFJysWYIWp0Qr6Ji/CNWHSIWN02sV9eSYdJmQTR+9EiSAAAAIQDGl0lOYKiMbcJy5zU/VDTm3M+Q2VFq+RMuOqNvLjm3qA==";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.k3s
    profiles.exporter.node
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = "2602:fed2:7106::1";
    interfaces = {
      ens3.ipv6 = {
        addresses = [
          {
            address = "2602:fed2:7106:271b::1";
            prefixLength = 64;
          }
        ];
        routes = [
          {
            address = "2602:fed2:7106::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Docker
  virtualisation.docker.enable = true;

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.34/24";
    ipv6 = "2602:feda:1bf:deaf::7/64";
  };

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 2602:fed2:7106:271b::1
        forward . 127.0.0.1
        cache 30
      }
    '';
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
