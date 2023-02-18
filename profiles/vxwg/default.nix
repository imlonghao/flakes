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
      hosthatchsestockholm1 = {
        publicKey = "se/imkItSqQt9xR0nUT6e1wnw8YmTjKhgc9a9ZSoamg=";
        id = 4;
        mac = "ba:a8:ba:ec:b9:2b";
        endpoint = "hosthatch-se-stockholm-1.ni.sb";
        port = 63004;
      };
      hosthatchsgsingapore1 = {
        publicKey = "vBcYFxMLwcsVScQ0LqkGDEIbbykskatmqWHlPGEUrE8=";
        id = 5;
        mac = "ce:b9:a1:c3:35:01";
        endpoint = "hosthatch-sg-singapore-1.ni.sb";
        port = 63005;
      };
      idcwikicnhongkong1 = {
        publicKey = "ihk/eiv2YL49Ig03iPb718FNUpO9Bs3ZGXRMke+WqA0=";
        id = 6;
        mac = "02:ed:53:c4:a5:f4";
        endpoint = "idcwiki-cn-hongkong-1.ni.sb";
        port = 63006;
      };
      misakadeberlin1 = {
        publicKey = "ber/iNS8hKD513kJ/sSTrYmpPZmELjVvyluZvaoCOTE=";
        id = 7;
        mac = "f2:3b:fb:38:0f:ac";
        endpoint = "misaka-de-berlin-1.ni.sb";
        port = 63007;
      };
    };
  };
}

