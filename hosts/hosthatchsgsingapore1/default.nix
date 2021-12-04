{ age, profiles, self, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.rait
    profiles.pingfinder
    profiles.coredns.dn42
    profiles.exporter.node
    profiles.exporter.bird
  ];

  boot.loader.grub.device = "/dev/vda";
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.defaultGateway6 = {
    address = "2406:ef80:2::1";
  };
  networking.interfaces.ens3.ipv6.addresses = [
    {
      address = "2406:ef80:2:e::";
      prefixLength = 48;
    }
  ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.2";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:2::";
      prefixLength = 64;
    }
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/var/jfsCache"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  services.gravity = {
    enable = true;
    address = "100.64.88.61/30";
    addressV6 = "2602:feda:1bf:a:10::1/80";
    hostAddress = "100.64.88.62/30";
    hostAddressV6 = "2602:feda:1bf:a:10::2/80";
  };

  # k3s server
  age.secrets."k3s.token".file = "${self}/secrets/k3s.token";
  services.k3s = {
    enable = true;
    role = "server";
  };
  services.k3s-no-ctstate-invalid.enable = true;

  # fish alias
  programs.fish.shellAliases = {
    k = "k3s kubectl";
  };

  # Docker
  virtualisation.docker.enable = true;

}
