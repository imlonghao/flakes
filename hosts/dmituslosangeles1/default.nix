{ pkgs, profiles, ... }: {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.sing-box
    profiles.rsshc
    profiles.exporter.node
    profiles.docker
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    dhcpcd.enable = false;
    defaultGateway = "154.17.16.1";
    defaultGateway6 = {
      address = "fe80::6436:5aff:fe53:bc6b";
      interface = "eth0";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "154.17.16.135";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2605:52c0:2:4ad::1";
          prefixLength = 64;
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

  sops.secrets.juicity.sopsFile = ./secrets.yml;
  services.juicity.enable = true;

  services.qemuGuest.enable = true;

  mptcp = {
    enable = true;
    endpoint = [
      {
        id = 1;
        address = "100.64.88.36";
        dev = "eg_net";
      }
      {
        id = 2;
        address = "104.192.93.183";
        dev = "eth0";
        port = 44444;
      }
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 23;
  };

}
