{ ... }:

{
  networking.interfaces.lo.ipv4.addresses = [
    { address = "172.22.68.8"; prefixLength = 32; }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    { address = "fd21:5c0c:9b7e::8"; prefixLength = 64; }
  ];
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 172.22.68.8 fd21:5c0c:9b7e::8
        hosts {
          172.22.68.0 anycast.imlonghao.dn42
          172.22.68.1 us1.imlonghao.dn42
          172.22.68.2 sg1.imlonghao.dn42
          172.22.68.3 hk1.imlonghao.dn42
          172.22.68.4 de1.imlonghao.dn42
          172.22.68.8 ns.imlonghao.dn42
        }
      }
    '';
  };
}
