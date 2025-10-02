{ config, ... }:
let
  ip = "100.64.1.${toString config.services.ranet.id}";
in
{
  services.etcd = {
    enable = true;
    advertiseClientUrls = [ "http://${ip}:2379" ];
    listenPeerUrls = [ "http://${ip}:2380" ];
    listenClientUrls = [
      "http://127.0.0.1:2379"
      "http://${ip}:2379"
    ];
    initialCluster = [
      "f4uskansas1=http://100.64.1.3:2380"
      "wirecatussantaclara1=http://100.64.1.18:2380"
      "oracledefrankfurt1=http://100.64.1.19:2380"
    ];
  };
}
