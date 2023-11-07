{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIJkcn7CZRV0AJS5OVOS4djzADm2NGnkhVqfcYylNI3HcAAAAIEDKHKwROvzT+PfWnMvG59cTVzMOvdI0rAGXYg7fYSEwAAAAAAAAAAAAAAACAAAAEWRtaXR1c2xvc2FuZ2VsZXMxAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABJAAAAIQC8NR3rzbl4mAm13UWv3H5VYacfyE2qaMnmMsaDXAZZPwAAACAEfC/bDSLHCnvhw25KcUN32Rfz9ZwtQ+Zrayz/ffyn2Q==";
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.netdata
    profiles.tuic
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    dhcpcd.enable = false;
    defaultGateway = "154.17.16.1";
    defaultGateway6 = "2605:52c0:2::1";
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "154.17.16.135"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2605:52c0:2:4ad::"; prefixLength = 48; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.36/24";
    ipv6 = "2602:feda:1bf:deaf::36/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

  sops.secrets.juicity.sopsFile = ./secrets.yml;
  services.juicity.enable = true;

}
