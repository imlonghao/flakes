{ pkgs, profiles, ... }: {
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.exporter.blackbox
    profiles.rsshc
    profiles.sing-box
    profiles.mtrsb
    profiles.docker
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "193.32.148.1";
    defaultGateway6 = "2a12:a301:2013::1";
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "193.32.149.99";
          prefixLength = 22;
        }];
        ipv6.addresses = [{
          address = "2a12:a301:2013::109a";
          prefixLength = 48;
        }];
      };
    };
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull" ];
  };

  environment.systemPackages = with pkgs; [ wgcf wireguard-tools ];

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 10;
  };

}
