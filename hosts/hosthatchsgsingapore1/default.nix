{ config, pkgs, profiles, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAINUBBpFCjltGQ4wILUgWGcq8j+1lfOmrNtAmvSD4BTjNAAAAIBID8nCh4rMu4rhADLBjHR4zUvNWKF7898FHzkrBKY3CAAAAAAAAAAAAAAACAAAAFWhvc3RoYXRjaHNnc2luZ2Fwb3JlMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACBdEjzv5Cm6q0ithPhtehNlLOAcwVuclnnKeE2MI7qeNgAAACEAsNIW/oXN1w4V5TL8vvVvYgfDX6p4uZiPzvN5B2urIzg=";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.docker
    profiles.autorestic
    profiles.bird-lg-go
  ];

  boot.loader.grub.device = "/dev/vda";
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  # networking.defaultGateway6 = {
  #   address = "2406:ef80:2::1";
  # };
  # networking.interfaces.ens3.ipv6.addresses = [
  #   {
  #     address = "2406:ef80:2:e::";
  #     prefixLength = 48;
  #   }
  # ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.2";
      prefixLength = 32;
    }
    { address = "172.22.68.8"; prefixLength = 32; }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:2::";
      prefixLength = 64;
    }
    { address = "fd21:5c0c:9b7e::8"; prefixLength = 128; }
  ];

  environment.systemPackages = with pkgs; [
    rclone
    tmux
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.62/24";
    ipv6 = "2602:feda:1bf:deaf::6/64";
  };

  # fish alias
  programs.fish.shellAliases = {
    k = "k3s kubectl";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  services.powerdns = {
    enable = true;
    extraConfig = ''
      local-address=172.22.68.8,fd21:5c0c:9b7e::8
      launch=gmysql
      gmysql-password=234567
      webserver-address=0.0.0.0
      webserver-allow-from=0.0.0.0/0
      api=yes
      api-key=$scrypt$ln=10,p=1,r=8$xgVRGiRQT3XsFZOMo/WfSw==$VSWbInxkxV7Bu+SpHuCh3K99iS4PJY+LTRksHnRgKAM=
      default-soa-content=ns.imlonghao.dn42. hostmaster.@ 0 7200 1800 1209600 3600
    '';
  };
  systemd.services.pdns.after = [ "etherguard-edge.service" ];
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # AutoRestic
  services.autorestic = {
    settings = {
      version = 2;
      global = {
        forget = {
          keep-hourly = 24;
          keep-daily = 7;
          keep-weekly = 4;
          keep-monthly = 6;
        };
      };
      backends = {
        garage = {
          type = "s3";
          path = "https://s3.esd.cc/restic";
        };
      };
      locations = {
        data = {
          from = [
            "/persist/docker"
            "/persist/etc"
          ];
          to = [
            "garage"
          ];
          cron = "0 1 * * *";
        };
      };
    };
  };

}
