{ pkgs, ... }:
let
  zone = pkgs.writeText "zonefile" ''
    97.96/27.51.20.172.in-addr.arpa. 3600 IN SOA imlonghao.dn42. dn42.esd.cc. 2021090201 7200 1800 1209600 3600
    0.0/27.68.22.172.in-addr.arpa. 3600 PTR anycast.imlonghao.dn42.
    1.0/27.68.22.172.in-addr.arpa. 3600 PTR us1.imlonghao.dn42.
    2.0/27.68.22.172.in-addr.arpa. 3600 PTR sg1.imlonghao.dn42.
    3.0/27.68.22.172.in-addr.arpa. 3600 PTR hk1.imlonghao.dn42.
    4.0/27.68.22.172.in-addr.arpa. 3600 PTR de1.imlonghao.dn42.
    5.0/27.68.22.172.in-addr.arpa. 3600 PTR us2.imlonghao.dn42.
    8.0/27.68.22.172.in-addr.arpa. 3600 PTR ns.imlonghao.dn42.
  '';
in {
  networking.interfaces.lo.ipv4.addresses = [{
    address = "172.22.68.8";
    prefixLength = 32;
  }];
  networking.interfaces.lo.ipv6.addresses = [{
    address = "fd21:5c0c:9b7e::8";
    prefixLength = 128;
  }];
  services.coredns = {
    enable = true;
    config = ''
      172.22.68.0/27 {
        bind 172.22.68.8 fd21:5c0c:9b7e::8
        file ${zone}
      }
    '';
  };
}
