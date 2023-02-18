{ config, lib, self, sops, ... }:

{
  sops.secrets.wireguard.sopsFile = lib.mkForce "${self}/hosts/${config.networking.hostName}/secrets.yml";
  vxwg = {
    enable = true;
    peers = {
      buyvmuslasvegas1 = {
        publicKey = "lAs/L2XLEZALnTOJ6ZhHaKgYY+rzqRgPnmlC4v/SfQw=";
        id = 1;
        mac = "c2:2e:1b:fc:26:c0";
        endpoint = "buyvm-us-lasvegas-1.ni.sb";
        port = 63001;
      };
      buyvmusmiami1 = {
        publicKey = "mia/xaadbAYxEXeMCjp1EnkcntJ09E8LIoEK471JNAA=";
        id = 2;
        mac = "a6:bf:3f:4e:2c:74";
        endpoint = "buyvm-us-miami-1.ni.sb";
        port = 63002;
      };
      hetznerdefalkenstein2 = {
        publicKey = "k9F2akSTkbA/GiO59PNW/v0D65ioMYD4P1DqeKSL3FM=";
        id = 3;
        mac = "d2:2d:e1:90:39:f5";
        endpoint = "138.201.124.182";
        port = 63003;
      };
    };
  };
}

